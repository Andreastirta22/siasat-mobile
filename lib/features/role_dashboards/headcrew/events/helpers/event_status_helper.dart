class EventStatusHelper {
  static String getStatusLabel(String status) {
    switch (status) {
      case 'manpower_filling':
        return 'Manpower Filling';

      case 'ready_for_activation':
        return 'Ready For Activation';

      case 'active':
        return 'Active';

      case 'completed':
        return 'Completed';

      default:
        return status;
    }
  }
}
