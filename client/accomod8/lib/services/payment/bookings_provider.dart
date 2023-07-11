abstract class BookingsProvider {
  Future<void> createBooking({
    required String userId,
    required String hostelId,
  });
}
