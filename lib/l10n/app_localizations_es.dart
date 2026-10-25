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
}
