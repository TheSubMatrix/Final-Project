using UnityEngine;

public static class SettingsManager
{
    public const string MusicVolumeKey  = "Music Volume";
    public const string SFXVolumeKey  = "SFX Volume";
    //Need to initialize player prefs so that they are loaded before the game starts. This is so that the resolution and fullscreen mode are set before the game starts.
    [RuntimeInitializeOnLoadMethod(RuntimeInitializeLoadType.BeforeSplashScreen)]
    public static void Initialize()
    {
        
    }
}
