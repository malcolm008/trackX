enum UserType { admin, schoolManager, parent, driver}

enum BusStatus { active, maintenance, inactive, onRoute, offDuty}

enum RouteStatus { active, inactive, delayed, cancelled, completed}

enum StudentStatus { present, absent, late, earlyPickup, notRegistered }

enum AttendanceStatus { present, absent, late, excused}

enum ReportType { mechanical, traffic, accident, studentBehavior, other}
enum ReportStatus { pending, resolved, inProgress, cancelled}

enum SubscriptionPlan { basic, premium, enterprise}
enum  PaymentStatus { pending, paid, failed, refunded, cancelled}

enum NotificationType { arrival, delay, attendance, emergency, system, reminder, routeUpdate, busUpdate }
enum NotificationPriority { low, medium, high, urgent}

enum TrackindStatus { stopped, tracking, paused, error}

enum SchoolType {preschool, elementary, middle, high, university, other}
