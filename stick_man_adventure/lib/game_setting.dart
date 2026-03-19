class GameSettings {
  static final GameSettings _instance = GameSettings._internal();
  
  factory GameSettings() {
    return _instance;
  }
  
  GameSettings._internal();
  
  double musicVolume = 0.7;
  double soundVolume = 0.5;
  
  // Метод для обновления настроек из SettingsScreen
  void updateSettings(double music, double sound) {
    musicVolume = music;
    soundVolume = sound;
  }
}