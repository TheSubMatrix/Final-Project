using System;
using MatrixUtils.AudioSystem;
using UnityEngine;
using UnityEngine.Audio;
using UnityEngine.UI;
public class SoundSettings : MonoBehaviour
{
    [SerializeField] private AudioMixer soundMixer;
    [SerializeField] private Slider volumeSliderSFX;
    [SerializeField] private Slider volumeSliderMusic;


    private void Start()
    {
        if (PlayerPrefs.HasKey("Music"))
        {
            volumeSliderMusic.value = PlayerPrefs.GetFloat("Music");
            
           
        }
        
        if (PlayerPrefs.HasKey("Sound Effects"))
        {
            volumeSliderSFX.value = PlayerPrefs.GetFloat("Sound Effects");
         
        }
        
      
        
      
    }

    public void SetMusicVolume()
    {
        float volume = Mathf.Log10(volumeSliderMusic.value) * 20;
        bool success = soundMixer.SetFloat("Music", volume);
        PlayerPrefs.SetFloat("Music", volumeSliderMusic.value);
        Debug.Log($"SetFloat success: {success}, volume sent: {volume}");
        soundMixer.GetFloat("Music", out var value);
        Debug.Log($"GetFloat returns: {value}");
    }
    
    
    public void SetSoundEffectsVolume()
    {
        
        float volume = Mathf.Log10(volumeSliderSFX.value) * 20;
        bool success = soundMixer.SetFloat("Sound Effects", volume);
        PlayerPrefs.SetFloat("Sound Effects", volumeSliderSFX.value);
        Debug.Log($"SetFloat success: {success}, volume sent: {volume}");
        soundMixer.GetFloat("Sound Effects", out var value);
        Debug.Log($"GetFloat returns: {value}");
    }
    
}
