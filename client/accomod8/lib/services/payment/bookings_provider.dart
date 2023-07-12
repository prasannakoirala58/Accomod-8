abstract class BookingsProvider {
  Future<String> createBooking({
    required String userId,
    required String hostelId,
    required int price,
  });
}
