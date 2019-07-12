class Config{
  // dev 开发环境；pre 验证环境； release 生产环境
  static final String context = 'dev';
  static final String baseUrl = context == 'dev' ? 'https://app.chayueshebao.com/' : 'https://app.joyshebao.com';
}