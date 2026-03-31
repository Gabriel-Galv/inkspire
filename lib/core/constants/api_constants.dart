class ApiConstants {
  ApiConstants._();

  // ─── Google Books API ─────────────────────────────────────────────────────
  static const googleBooksBaseUrl = 'https://www.googleapis.com/books/v1';

  // API Key opcional:
  //   Sin key  → 1,000 requests/día
  //   Con key  → 1,000,000 requests/día
  // Obtén una en: console.cloud.google.com → Credentials → Create API Key
  static const googleBooksApiKey = '';

  // ─── Parámetros de búsqueda ───────────────────────────────────────────────
  static const defaultMaxResults    = 20;
  static const featuredMaxResults   = 10;
  static const connectTimeoutSec    = 10;
  static const receiveTimeoutSec    = 15;
}