class RoleFormatter {
  static String format(String role) {
    switch (role) {
      case 'founder':
        return 'Founder';

      case 'principal':
        return 'Principal';

      case 'finance_office':
        return 'Finance Office';

      case 'event_manager':
        return 'Event Manager';

      case 'headcrew':
        return 'Headcrew';

      case 'crew':
        return 'Crew';

      case 'coach':
        return 'Coach';

      default:
        return role;
    }
  }
}
