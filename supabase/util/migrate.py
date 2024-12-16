from datetime import datetime
import os
import secrets

import pandas as pd

from google.cloud.firestore_v1 import FieldFilter
from google.cloud.firestore_v1.client import Client

import supabase

# ! Ensure GOOGLE_APPLICATION_CREDENTIALS is set
firestore_client = Client()
schedules = firestore_client.collection("schedules").get()

url: str = os.environ.get("SUPABASE_URL")
key: str = os.environ.get("SUPABASE_KEY")
supabase_client = supabase.create_client(url, key)


def replies_after_date(timestamp: datetime):
    events_after_today = (
        firestore_client.collection("events")
        .where(filter=FieldFilter("timestamp", ">=", timestamp))
        .stream()
    )

    for e in events_after_today:
        schedule_id = e.get("schedule").id
        event_date = e.get("timestamp")

        attendees = e.reference.collection("attendees").stream()
        for a in attendees:
            yield schedule_id, event_date, a.id, a.get("reply")


# TODO Use for prod
TIMESTAMP = datetime.now()
# TIMESTAMP = datetime(2022, 1, 1)

replies = pd.DataFrame(
    replies_after_date(TIMESTAMP),
    columns=["schedule_id", "instance_date", "attendee_id", "selected_option"],
)

# TODO Fix this tz shit
replies["instance_date"] = replies["instance_date"].dt.tz_convert("Europe/Rome")

replies["instance_date"] = replies["instance_date"].dt.strftime("%Y-%m-%dT%H:%M:%SZ")

# ! Must manually create a group first
# TODO Change in prod
group_id = "0193d166-5d6b-705f-a051-b4ea865456af"

invitees = pd.DataFrame(schedules[0].get("invitees"))
invitees["group_id"] = group_id
members = (
    invitees[["displayName", "group_id"]]
    .rename(columns={"displayName": "display_name_override"})
    .to_dict("records")
)
inserted_members = supabase_client.table("members").upsert(members).execute()

member_ids = [d["id"] for d in inserted_members.data]
invitees["member_id"] = member_ids
map_phone_to_member_id = {
    invitee["phoneNumber"]: invitee["member_id"]
    for member_id, invitee in invitees.iterrows()
}
replies["member_id"] = replies["attendee_id"].map(map_phone_to_member_id)

# ! Must create 2 schedules first, at 13:15 and 19:30
# TODO Change in prod
# map_schedule_id_to_supabase_id = {
#     'fVeeQLNT0A4mduJb9tCx': 4,
#     'eJpPQuHYpurvxhYSzYqh': 6,
# }
map_schedule_id_to_supabase_id = {
    "AGvmeGq4sVMntxmIBhJn": "0193d166-9c0d-7339-902c-2c67593d3011",  # Pranzo
    "9dA4LAjp5hjh3bQ82S4p": "0193d166-c307-7e06-b56f-969775f051c3",  # Cena
}
replies["schedule_id"] = replies["schedule_id"].map(map_schedule_id_to_supabase_id)

# supabase_client.table("replies").upsert(
#     replies[["member_id", "schedule_id", "instance_date", "selected_option"]]
#     .dropna()
#     .to_dict("records")
# ).execute()


invites = invitees[["member_id", "phoneNumber"]].rename(
    columns={"phoneNumber": "value"}
)
invites["method"] = "phone"
supabase_client.table("invites").upsert(invites.to_dict("records")).execute()

CROCKFORD = "0123456789ABCDEFGHJKMNPQRSTVWXYZ"


def generate_invite_code():
    def generate_id():
        return "".join(secrets.choice(CROCKFORD) for i in range(4))

    return f"{generate_id()}-{generate_id()}"


invites_with_codes = invites.copy()
invites_with_codes["value"] = invites_with_codes["member_id"].apply(
    lambda _: generate_invite_code()
)
invites_with_codes["method"] = "code"
supabase_client.table("invites").upsert(invites_with_codes.to_dict("records")).execute()
