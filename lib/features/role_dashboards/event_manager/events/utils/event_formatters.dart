String formatStatus(String status) {
  return status
      .replaceAll('_', ' ')
      .split(' ')
      .map((w) => w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

String formatEventType(String type) {
  switch (type) {
    case 'ice_skating':
      return 'Ice Skating';

    case 'operational_event':
      return 'Operational Event';

    case 'playground':
      return 'Playground';

    default:
      return type
          .replaceAll('_', ' ')
          .split(' ')
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(' ');
  }
}
