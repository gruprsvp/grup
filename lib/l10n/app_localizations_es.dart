// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'GRUP';

  @override
  String get addContact => 'Añade un contacto';

  @override
  String get addInvite => 'Añade una invitación';

  @override
  String get camera => 'Cámara';

  @override
  String get cancel => 'Cancela';

  @override
  String get changeTheme => 'Tema';

  @override
  String get chooseNewProfilePicture => 'Elige una nueva foto de perfil';

  @override
  String get confirm => 'Confirma';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactName => 'Nombre';

  @override
  String get contactPhone => 'Teléfono';

  @override
  String get contacts => 'Contactos';

  @override
  String get contactNew => 'Nuevo contacto';

  @override
  String get contactsPermission => 'Permiso para los contactos';

  @override
  String get contactsPermissionMessage =>
      'Para invitar a tus amigos a grupos, necesitas darnos acceso a tus contactos';

  @override
  String get copiedToClipboard => 'Copiado al portapapeles';

  @override
  String get copy => 'Copia';

  @override
  String get create => 'Crea';

  @override
  String get createNewEvent => 'Crea un evento nuevo';

  @override
  String get createNewGroup => 'Crea un grupo nuevo';

  @override
  String get createOrJoinGroup => 'Crea o únete a un grupo';

  @override
  String get defaultRulesExplanation =>
      'Tu respuesta habitual se aplica a cada evento que cubre, así cuentas sin responder cada vez. Aún puedes cambiar cualquier día.';

  @override
  String get defaultRulesWeekdays => 'Días laborables';

  @override
  String get defaultRulesWeekends => 'Fines de semana';

  @override
  String get delete => 'Eliminar';

  @override
  String get deleteGroup => 'Eliminar grupo';

  @override
  String get deleteGroupConfirmation =>
      '¿Estás seguro de que quieres eliminar este grupo?';

  @override
  String get deleteProfile => 'Eliminar perfil';

  @override
  String get deleteProfileConfirmation =>
      '¿Estás seguro de que quieres eliminar tu perfil?';

  @override
  String get deleteSchedule => 'Eliminar evento';

  @override
  String get deleteScheduleConfirmation =>
      '¿Estás seguro de que quieres eliminar este evento?';

  @override
  String get details => 'Detalles';

  @override
  String get enterGroupDescription =>
      'Puedes poner una descripción del grupo si quieres';

  @override
  String get enterGroupName => 'Ponle un nombre al grupo';

  @override
  String get enterGroupNamePlease => 'Necesitamos un nombre para el grupo';

  @override
  String get enterInviteCode => 'Pon el código de invitación';

  @override
  String get enterInviteCodePlease => 'Necesitamos un código de invitación';

  @override
  String get enterYourName => 'Pon tu nombre';

  @override
  String get enterYourNamePlease => 'Necesitamos un nombre';

  @override
  String get eventDatetime => 'Fecha y hora del evento';

  @override
  String get eventName => 'Nombre del evento';

  @override
  String get events => 'Eventos';

  @override
  String get eventsEmpty =>
      '¡Es hora de dar vida a tu grupo!<br/>Toca el botón <newevent/> para programar tu primera actividad.<br/>Elige una fecha, establece una hora y añade detalles para que todos estén emocionados de reunirse.';

  @override
  String feedbackEmailCantSend(Object email) {
    return 'No se pudo abrir un cliente de correo electrónico. Puedes enviarnos un correo electrónico a $email';
  }

  @override
  String get feedbackEmailSubject => 'Feedback para GRUP';

  @override
  String get feedbackEmailBody =>
      'Hola equipo de GRUP,\n\nTengo algunos comentarios para vosotros:\n\n';

  @override
  String get feedbackPromptTitle => '¿Cómo lo estamos haciendo?';

  @override
  String get feedbackPromptBody =>
      'Si te gusta <title>GRUP</title>, por favor déjanos una reseña positiva para llegar a más personas.\nSi tienes algún comentario, por favor háznoslo saber para que podamos mejorar.';

  @override
  String feedbackStoreReview(Object store) {
    return 'Déjanos una reseña en $store';
  }

  @override
  String get feedbackTellUs => 'Envíanos un mensaje';

  @override
  String get gallery => 'Galería';

  @override
  String get groupDismissAdmin => 'Descarta como admin';

  @override
  String get groupDismissAdminConfirmation =>
      '¿Seguro que quieres descartar a este miembro como admin?';

  @override
  String get groupEmptyEventsUser =>
      'Este grupo aún no tiene eventos.<br/>Cuando un administrador añada uno, aparecerá aquí y responderás con un toque.';

  @override
  String get groupLeave => 'Abandona el grupo';

  @override
  String get groupLeaveConfirmation =>
      '¿Seguro que quieres abandonar este grupo? Perderás el acceso a todos los eventos y miembros del grupo.';

  @override
  String get groupMakeAdmin => 'Haz admin del grupo';

  @override
  String get groupMakeAdminConfirmation =>
      '¿Seguro que quieres hacer a este miembro admin?';

  @override
  String get groupManage => 'Gestionar grupo';

  @override
  String get grantPermission => 'Da permiso';

  @override
  String get groupRemoveMember => 'Quita del grupo';

  @override
  String get groupRemoveConfirmation =>
      '¿Seguro que quieres quitar a este miembro del grupo?';

  @override
  String groupRoles(String role) {
    String _temp0 = intl.Intl.selectLogic(role, {
      'admin': 'Admin',
      'member': 'Miembro',
      'other': 'Desconocido',
    });
    return '$_temp0';
  }

  @override
  String get guest => 'Invitado';

  @override
  String get invite => 'Invita a la gente';

  @override
  String inviteCodeExplanation(String user) {
    return 'Comparte este código con $user para invitarlo al grupo';
  }

  @override
  String inviteMessage(String code, String link) {
    return '¡Ey, únete a mi grupo en GRUP! Usa este código $code o haz clic aquí: $link';
  }

  @override
  String get invites => 'Invitaciones';

  @override
  String get invitesEmpty =>
      '¡Es hora de invitar a tus amigos a unirse a tus grupos!<br/>Toca el botón <invite/> para invitar a tus amigos a unirse a tus grupos y empezar a organizar eventos juntos.';

  @override
  String get inviteFromContacts => 'Invita desde tus contactos';

  @override
  String get inviteManual => 'Invita manualmente';

  @override
  String get inviteMembersCTA => '¡Invita a algunos amigos!';

  @override
  String get join => 'Únete';

  @override
  String get joinGroup => 'Únete al grupo';

  @override
  String get language => 'Idioma';

  @override
  String get loading => 'Cargando...';

  @override
  String get members => 'Miembros';

  @override
  String get newGroup => 'Grupo nuevo';

  @override
  String get no => 'No';

  @override
  String get profile => 'Perfil';

  @override
  String get recurrenceRule => 'Recurrencia';

  @override
  String get save => 'Guarda';

  @override
  String get selectContacts => 'Elige contactos';

  @override
  String get settings => 'Configuraciones';

  @override
  String get settingsMoreInfo => 'Más información';

  @override
  String get signOut => 'Cierra sesión';

  @override
  String get signOutConfirmation => '¿Seguro que quieres cerrar sesión?';

  @override
  String get systemLanguage => 'Idioma del sistema';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get unknown => 'Desconocido';

  @override
  String get yes => 'Sí';

  @override
  String get you => 'Tú';

  @override
  String get errorNetwork =>
      'No se pudo conectar con GRUP. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get errorNotFound =>
      'Esto ya no está disponible. Puede que se haya eliminado o que ya no tengas acceso.';

  @override
  String get errorNotAllowed => 'No tienes permiso para hacer eso.';

  @override
  String get errorInvalidInviteCode =>
      'Este código de invitación no es válido. Revísalo e inténtalo de nuevo.';

  @override
  String get errorAlreadyMember => 'Ya eres miembro de este grupo.';

  @override
  String get errorNotSignedIn =>
      'Has cerrado sesión. Inicia sesión e inténtalo de nuevo.';

  @override
  String get errorGeneric => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get retry => 'Reintentar';

  @override
  String get joiningGroup => 'Uniéndote al grupo…';

  @override
  String get joinedGroup => '¡Te has unido al grupo!';

  @override
  String get goToGroups => 'Ir a tus grupos';

  @override
  String get licenses => 'Licencias';

  @override
  String get recurrenceOnce => 'Una vez';

  @override
  String get recurrenceDaily => 'Todos los días';

  @override
  String get recurrenceWeekly => 'Todas las semanas';

  @override
  String get recurrenceMonthly => 'Todos los meses';

  @override
  String get recurrenceYearly => 'Todos los años';

  @override
  String get recurrenceWeekdays => 'Entre semana';

  @override
  String get recurrenceWeekends => 'Los fines de semana';

  @override
  String get recurrenceCustom => 'Personalizada';

  @override
  String get authEnterEmail => 'Introduce tu correo electrónico';

  @override
  String get authValidEmailError => 'Introduce un correo electrónico válido';

  @override
  String get authEnterPassword => 'Introduce tu contraseña';

  @override
  String get authPasswordLengthError =>
      'Introduce una contraseña de al menos 6 caracteres';

  @override
  String get authSignIn => 'Iniciar sesión';

  @override
  String get authSignUp => 'Registrarse';

  @override
  String get authForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get authDontHaveAccount => '¿No tienes cuenta? Regístrate';

  @override
  String get authHaveAccount => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get authSendPasswordReset =>
      'Enviar correo para restablecer la contraseña';

  @override
  String get authPasswordResetSent =>
      'Te hemos enviado un correo para restablecer la contraseña';

  @override
  String get authBackToSignIn => 'Volver a iniciar sesión';

  @override
  String get authUnexpectedError => 'Se produjo un error inesperado';

  @override
  String get authRequiredFieldError => 'Este campo es obligatorio';

  @override
  String get authConfirmPasswordError => 'Las contraseñas no coinciden';

  @override
  String get authConfirmPassword => 'Confirmar contraseña';

  @override
  String get authEnterOtpCode => 'Introduce el código de verificación';

  @override
  String get authEnterNewPassword => 'Introduce una contraseña nueva';

  @override
  String get authChangePassword => 'Cambiar contraseña';

  @override
  String get authPasswordChangedSuccess => 'Contraseña actualizada';

  @override
  String get authOtpCodeError => 'Código de verificación no válido';

  @override
  String get authOtpDisabledError =>
      'Los códigos de verificación están desactivados';

  @override
  String get authEnterPhoneNumber => 'Introduce tu número de teléfono';

  @override
  String get authValidPhoneNumberError =>
      'Introduce un número de teléfono válido';

  @override
  String get authContinueWithMagicLink => 'Continuar con enlace mágico';

  @override
  String get authCheckYourEmail => '¡Revisa tu correo!';

  @override
  String get authSuccessSignInMessage => '¡Sesión iniciada!';

  @override
  String get authUpdatePassword => 'Actualizar contraseña';

  @override
  String get authEnterOneTimeCode =>
      'Introduce el código de un solo uso que te enviamos';

  @override
  String get authEnterCodeSent => 'Introduce el código enviado';

  @override
  String get authVerifyPhone => 'Verificar teléfono';

  @override
  String authContinueWithProvider(String provider) {
    return 'Continuar con $provider';
  }

  @override
  String get updateRequiredTitle => 'Actualiza GRUP';

  @override
  String get updateRequiredBody =>
      'Esta versión de GRUP ya no es compatible. Actualiza la app para seguir usándola.';

  @override
  String get updateRequiredAction => 'Actualizar';

  @override
  String get notFoundTitle => 'Página no encontrada';

  @override
  String get notFoundBody =>
      'Este enlace no lleva a nada en GRUP. Puede que esté mal escrito o que lo que enlazaba ya no exista.';

  @override
  String get notFoundAction => 'Ir a tus grupos';

  @override
  String eventComing(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Van $count',
      one: 'Va 1',
    );
    return '$_temp0';
  }

  @override
  String eventUsually(int count) {
    return '+$count de costumbre';
  }

  @override
  String eventOut(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count no van',
      one: '1 no va',
    );
    return '$_temp0';
  }

  @override
  String eventNoReply(int count) {
    return '$count sin respuesta';
  }

  @override
  String get noReplyYet => 'Sin respuesta aún';

  @override
  String get previousDay => 'Día anterior';

  @override
  String get nextDay => 'Día siguiente';

  @override
  String get noEventsThisDay => 'No hay eventos este día.';

  @override
  String nextEvent(String event, String date) {
    return 'Siguiente: $event, $date';
  }

  @override
  String get eventNotFound => 'Este evento no es en este día.';

  @override
  String get usualAnswer => 'respuesta habitual';

  @override
  String get answerComing => 'va';

  @override
  String get answerNotComing => 'no va';

  @override
  String get answerUsuallyComing => 'suele ir';

  @override
  String get answerUsuallyNotComing => 'no suele ir';

  @override
  String get answerNoReply => 'sin respuesta aún';

  @override
  String get usualAnswerYours => 'Tu respuesta habitual';

  @override
  String usualAnswerFor(String name) {
    return 'Respuesta habitual de $name';
  }

  @override
  String get usualEveryTime => 'Siempre';

  @override
  String get usuallyIn => 'Suele ir';

  @override
  String get usuallyOut => 'No suele ir';

  @override
  String usuallyInWhen(String when) {
    return 'Suele ir · $when';
  }

  @override
  String usuallyOutWhen(String when) {
    return 'No suele ir · $when';
  }

  @override
  String get setUsualAnswer => 'Elige tu respuesta habitual';

  @override
  String get usualAnswerSaved => 'Respuesta habitual guardada';

  @override
  String get usualAnswerRemoved => 'Respuesta habitual eliminada';

  @override
  String get undo => 'Deshacer';

  @override
  String markedComing(String name) {
    return '$name marcado como que va';
  }

  @override
  String markedNotComing(String name) {
    return '$name marcado como que no va';
  }

  @override
  String answerCleared(String name) {
    return 'Respuesta de $name borrada';
  }

  @override
  String get onboardingWelcome =>
      'Te damos la bienvenida a <title>GRUP</title>';

  @override
  String get onboardingTagline => 'Sabe quién viene sin tener que preguntar.';

  @override
  String get onboardingExampleEvent => 'Fútbol del martes';

  @override
  String get onboardingExampleCaption =>
      'Cada evento te muestra quién viene. Las respuestas habituales cuentan aparte hasta que la gente confirma.';

  @override
  String get onboardingStepGroup => 'Crea un grupo';

  @override
  String get onboardingStepGroupHint =>
      'Para la gente con la que quedas: un equipo, un club, amigos o familia.';

  @override
  String get onboardingStepEvent => 'Añade sus eventos';

  @override
  String get onboardingStepEventHint =>
      'Haz que uno se repita si quedáis cada semana.';

  @override
  String get onboardingStepInvite => 'Invita a tu gente';

  @override
  String get onboardingStepInviteHint =>
      'Responden con un toque, o eligen una vez su respuesta habitual.';

  @override
  String get onboardingJoin => 'Unirse con un código de invitación';

  @override
  String get groupSetupTitle => 'Pon en marcha tu grupo';

  @override
  String get groupSetupBody =>
      'Aquí aparecen sus eventos, con quién viene a cada uno.';

  @override
  String get groupSetupEvent => 'Añade el primer evento';

  @override
  String get profileNameHelper =>
      'Tus grupos ven este nombre junto a tus respuestas.';

  @override
  String get signUpCheckEmail =>
      'Ya casi está: abre el enlace del correo que te hemos enviado para terminar de registrarte.';

  @override
  String get analyticsTitle => 'Ayúdanos a dejar de adivinar';

  @override
  String get analyticsBody =>
      'Comparte qué funciones usas y construiremos lo que importa. Contamos toques, no secretos. Nunca anuncios.';

  @override
  String get analyticsYes => 'Me apunto';

  @override
  String get analyticsNo => 'Paso';

  @override
  String get analyticsSetting => 'Ayuda a mejorar GRUP';

  @override
  String get analyticsSettingSubtitle => 'Contamos toques, no secretos.';

  @override
  String get errorGroupFull => 'Todas las plazas de este grupo están ocupadas.';

  @override
  String get errorFeatureLocked => 'El plan de este grupo no lo incluye.';

  @override
  String get errorReplyLocked =>
      'Los cambios para este evento están cerrados. Pídeselo a un admin.';

  @override
  String get errorAlreadyFunded => 'Este grupo ya tiene un plan.';

  @override
  String get planTitle => 'Plan';

  @override
  String get planFree => 'Gratis';

  @override
  String planName(String plan) {
    String _temp0 = intl.Intl.selectLogic(plan, {
      'community_s': 'Crew',
      'community_m': 'Club',
      'community_l': 'Crowd',
      'other': 'Plan',
    });
    return '$_temp0';
  }

  @override
  String planFounderTrial(String date) {
    return 'Ventaja de fundador: todo lo que incluye un plan, gratis hasta el $date';
  }

  @override
  String get planLegacy => 'Grupo fundador: sin límite de plazas, para siempre';

  @override
  String planEarlyAccess(String date) {
    return 'Acceso anticipado a las novedades hasta el $date';
  }

  @override
  String get planExtra => 'Funciones extra de GRUP';

  @override
  String planExtraUntil(String date) {
    return 'Funciones extra de GRUP hasta el $date';
  }

  @override
  String planFundedBy(String payer) {
    return 'Pagado por $payer';
  }

  @override
  String planFundedRenews(String payer, String date) {
    return 'Pagado por $payer · se renueva el $date';
  }

  @override
  String planFundedEnds(String payer, String date) {
    return 'Pagado por $payer · termina el $date';
  }

  @override
  String get planYou => 'ti';

  @override
  String get planSomeone => 'alguien';

  @override
  String planPaymentIssue(String payer) {
    return 'Problema con el pago: $payer tiene que actualizar su método de pago';
  }

  @override
  String get planPaymentIssueYou =>
      'Problema con el pago: actualiza tu método de pago';

  @override
  String planSeats(int seats, int limit) {
    return '$seats de $limit plazas ocupadas';
  }

  @override
  String get planNoSeatLimit => 'Sin límite de plazas';

  @override
  String get planSeatsFull =>
      'Tu grupo está lleno. Para invitar a más gente, elige un plan o libera una plaza.';

  @override
  String planSpotsTaken(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count plazas ocupadas',
      one: '1 plaza ocupada',
    );
    return '$_temp0';
  }

  @override
  String get planSeatsFullPaid =>
      'Tu grupo está lleno. Para invitar a más gente, cambia a un tamaño mayor o libera una plaza.';

  @override
  String get planPendingInvites =>
      'Las invitaciones pendientes también ocupan una plaza. Los invitados por los que respondes son gratis.';

  @override
  String get planChoose => 'Elige un plan';

  @override
  String get planMonthly => 'Mensual';

  @override
  String get planYearly => 'Anual';

  @override
  String planUpToSeats(int count) {
    return 'Hasta $count personas';
  }

  @override
  String planPerMonth(String price) {
    return '$price al mes';
  }

  @override
  String planPerYear(String price) {
    return '$price al año';
  }

  @override
  String get planRecommended => 'Ideal para tu grupo';

  @override
  String get planContactUs => '¿Más de 80 personas? Escríbenos';

  @override
  String get planFounderDiscount =>
      'Tu descuento de fundador resta un 30 % al pagar.';

  @override
  String planBillingStarts(String date) {
    return 'No pagas nada hasta el $date, cuando termina tu ventaja de fundador.';
  }

  @override
  String get planSubscribe => 'Continuar al pago';

  @override
  String get planActivating => '¡Gracias! Activando tu plan…';

  @override
  String get planActivationSlow =>
      'Pago recibido. La activación tarda más de lo normal; recarga en un minuto.';

  @override
  String get planManageBilling => 'Gestionar la facturación';

  @override
  String get settingsBillingSubtitle =>
      'Facturas, método de pago y cancelación';

  @override
  String featureName(String feature) {
    String _temp0 = intl.Intl.selectLogic(feature, {
      'kitchen_view': 'Vista de cocina',
      'reply_cutoffs': 'Plazos de respuesta',
      'export_csv': 'Exportar a hoja de cálculo',
      'other': 'Otra',
    });
    return '$_temp0';
  }

  @override
  String get seatsFullHint =>
      'Quita miembros o invitaciones pendientes para liberar una plaza.';

  @override
  String get seePlans => 'Ver planes';

  @override
  String featurePitch(String feature) {
    String _temp0 = intl.Intl.selectLogic(feature, {
      'kitchen_view': 'El recuento de cada día con nombres, listo para imprimir para la cocina.',
      'reply_cutoffs': 'Las respuestas se cierran antes del evento, así el recuento no cambia.',
      'export_csv': 'Descarga las respuestas de todos en una hoja de cálculo.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get planRoomTitle => 'Espacio para crecer';

  @override
  String get planPerksEvery => 'Todos los planes incluyen';

  @override
  String get planPerksYours => 'Tu plan incluye';

  @override
  String planFrom(String price) {
    return 'Planes desde $price al mes';
  }

  @override
  String get planSizeTitle => 'Elige un tamaño';

  @override
  String planSizeHint(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Ahora usas $count plazas. Todos los tamaños incluyen todas las ventajas.',
      one: 'Ahora usas 1 plaza. Todos los tamaños incluyen todas las ventajas.',
    );
    return '$_temp0';
  }

  @override
  String get planTooSmall => 'Demasiado pequeño para tu grupo';

  @override
  String get planYearlySaving => '2 meses gratis';

  @override
  String planYearlyNudge(String price) {
    return 'O $price al año: 2 meses gratis';
  }

  @override
  String get planFinePrint =>
      'IVA incluido. Verás el precio final antes de pagar. Cancela cuando quieras.';

  @override
  String get planManageHint =>
      'Cambia el tamaño o el método de pago, descarga facturas o cancela.';

  @override
  String get planCardUpsell => 'Más plazas y ventajas con Crew, Club o Crowd';

  @override
  String get planCardFull => 'Tu grupo está lleno. Haz sitio con un plan.';

  @override
  String get planCardSee => 'Ver tu plan';

  @override
  String planWelcome(String plan) {
    return '¡Te damos la bienvenida a $plan! Todas las ventajas están activas.';
  }

  @override
  String get cutoffLabel => 'Cierre de cambios';

  @override
  String get cutoffNone => 'Sin plazo';

  @override
  String cutoffHours(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours horas antes',
      one: '1 hora antes',
      zero: 'Al empezar',
    );
    return '$_temp0';
  }

  @override
  String get cutoffCustom => 'Personalizado…';

  @override
  String get cutoffCustomTitle => 'Horas antes del inicio';

  @override
  String changesClosedAt(String time) {
    return 'Cambios cerrados a las $time';
  }

  @override
  String get lateChange => 'Cambio tardío';

  @override
  String get kitchenTitle => 'Vista de cocina';

  @override
  String kitchenMembers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String kitchenGuests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count invitados',
      one: '1 invitado',
    );
    return '$_temp0';
  }

  @override
  String get kitchenLate => 'Cambiado tarde';

  @override
  String get kitchenPrint => 'Imprimir';

  @override
  String get kitchenNobody => 'Todavía no va nadie.';

  @override
  String get featureUnavailable => 'No está disponible para este grupo.';

  @override
  String get exportAnswers => 'Exportar respuestas';

  @override
  String get exportTooLong => 'Elige como máximo un año.';

  @override
  String cutoffMinutes(int minutes) {
    return '$minutes min antes';
  }

  @override
  String get cutoffCustomInvalid => 'Introduce de 0 a 168 horas.';

  @override
  String get inviteCreateCode => 'Crear un código de invitación';

  @override
  String guestNoInvite(String name) {
    return '$name no tiene invitación: los admins responden en su lugar.';
  }

  @override
  String get inviteCancel => 'Cancelar invitaciones';

  @override
  String get inviteCancelHint =>
      'Sigue en el grupo, los admins responden en su lugar, y libera una plaza.';
}
