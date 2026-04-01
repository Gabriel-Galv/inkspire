class ApiConstants {
  ApiConstants._();

  // ─── Google Books API ─────────────────────────────────────────────────────
  static const googleBooksBaseUrl = 'https://www.googleapis.com/books/v1';

  // API Key opcional:
  //   Sin key  → 1,000 requests/día
  //   Con key  → 1,000,000 requests/día
  // Obtén una en: console.cloud.google.com → Credentials → Create API Key
  static const googleBooksApiKey = 'AIzaSyB1o2gnFcdDH197v_0cPKTLxaq3y4D66xM';

  // ─── Parámetros de búsqueda ───────────────────────────────────────────────
  static const defaultMaxResults    = 20;
  static const featuredMaxResults   = 10;
  static const connectTimeoutSec    = 20;  // Aumentado: evita timeouts en conexiones lentas
  static const receiveTimeoutSec    = 30;  // Aumentado: Google Books API puede tardar más
}