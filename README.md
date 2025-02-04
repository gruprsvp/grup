<div align="center">

# GRUP

**Event Scheduling for Groups**

With GRUP, you can create recurring events, invite friends, and keep track of their RSVPs.

The app is built with Flutter[^flutter] and Supabase[^supabase] - and is available on Android, iOS, and web.

[![AGPL-3.0](https://img.shields.io/github/license/gruprsvp/grup?style=flat-square)](./LICENSE)

<picture>
<source srcset="https://www.grup.rsvp/images/logo-darkmode.png" media="(prefers-color-scheme: dark)"/>
<img src="https://www.grup.rsvp/images/logo.png" alt="GRUP Logo"/>
</picture>

### Download the app

[![Apple App Store](https://img.shields.io/itunes/v/6473851276?style=for-the-badge&logo=appstore&label=Apple%20App%20Store&color=%230D96F6)](https://apps.apple.com/us/app/shared-calendar-events-grup/id6473851276)
[![Google Play](https://img.shields.io/itunes/v/6473851276?style=for-the-badge&logo=googleplay&label=Play%20Store&color=%23000000)](https://play.google.com/store/apps/details?id=is.giorgio.app.parousia)

**Or access it on web**

[![Web App](https://img.shields.io/website?url=https%3A%2F%2Fgrup.rsvp&style=for-the-badge&logo=flutter&logoColor=%2302569B&label=Web%20App&labelColor=%23FAFAFA)](https://grup.rsvp/)

</div>

<picture>
<source srcset="https://www.grup.rsvp/images/service-1-darkmode.png" media="(prefers-color-scheme: dark)"/>
<img src="https://www.grup.rsvp/images/service-1.png" alt="Screenshot showing groups"/>
</picture>

## :question: FAQ

### What is GRUP?

GRUP is an event scheduling app that allows you to create recurring events, invite friends,
and keep track of their RSVPs.

### How is it different from other calendar apps?

One of the core tenets of GRUP is simplicity. As there are many calendar apps out there,
we wanted to create a tool that is easy to use and focused on group events.

GRUP (as the name suggests) is all about groups. First, you create a group (or join one),
then you can create events that are shared with the group members.

It also has a particular focus on recurring events, so that you can set them up once and forget.

### How do I invite friends?

Once you create a group, you have 3 options to invite friends:

1. Share a single-use invite code;
2. Add a friend by email;
3. Add a friend by phone number.

### Do I need an account to use GRUP?

Yes, you need an account to use GRUP. We are investigating ways to allow anonymous users to join groups
in discussion https://github.com/gruprsvp/grup/discussions/148 - feel free to join the conversation!

### What if my friends don't have the app?

If your friends don't want to install the app, they can still access the event on the web.

If they don't want to interact at all, admins can still track their RSVPs in the app.

We are discussing how to allow users to reply to single events without having to sign up here: ttps://github.com/gruprsvp/grup/discussions/148

### I have a recurring event, and users have a default RSVP. How does that work?

When you create a recurring event, each user can set a default RSVP for that event.

For example, if you have a daily event (including weekends), and you always attend during the week,
you can set your "default reply" to "weekdays" and be marked as attending for all weekdays.

### I need a recurring event that doesn't follow a simple pattern. Can I do that?

Not yet, but we are working on it! Check out https://github.com/gruprsvp/grup/discussions/154 for more information.

### I have a feature request. How can I submit it?

Check out the [discussions](https://github.com/gruprsvp/grup/discussions) section.
If you don't see a topic that matches your idea or question,
feel free to start a new one!

## :computer: Contributing

If you want to contribute to the project, please read the [CONTRIBUTING.md](./CONTRIBUTING.md) file.

It contains information on how to set up your development environment, submit issues, and create pull requests.

## :scroll: License

This project is licensed under the [AGPL-3.0](./LICENSE) license.

You are free to use, modify, and distribute the code as long as you keep the same license,
and you distribute the source code along with the web publication.

> The AGPL license differs from the other GNU licenses in that it was built for network software.
> You can distribute modified versions if you keep track of the changes and the date you made them.
> As per usual with GNU licenses, you must license derivatives under AGPL.
> It provides the same restrictions and freedoms as the GPLv3 but with an additional clause which
> makes it so that source code must be distributed along with web publication.
> Since web sites and services are never distributed in the traditional sense,
> the AGPL is the GPL of the web. [^tldr-legal]


[^flutter]: https://flutter.dev

[^supabase]: https://supabase.com

[^tldr-legal]: https://www.tldrlegal.com/license/gnu-affero-general-public-license-v3-agpl-3-0
