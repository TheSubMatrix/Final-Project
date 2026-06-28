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
        if(soundMixer.GetFloat("Sound Effects", out float var))
            volumeSliderSFX.value = Mathf.Pow(10,var / 20) ;
        
        if(soundMixer.GetFloat("Music", out float var2))
            volumeSliderMusic.value = Mathf.Pow(10,var2 / 20) ;
    }

    public void SetMusicVolume()
    {
        float volume = Mathf.Log10(volumeSliderMusic.value) * 20;
        bool success = soundMixer.SetFloat("Music", volume);
        Debug.Log($"SetFloat success: {success}, volume sent: {volume}");
        soundMixer.GetFloat("Music", out var value);
        Debug.Log($"GetFloat returns: {value}");
    }
    
    
    public void SetSoundEffectsVolume()
    {
        
        float volume = Mathf.Log10(volumeSliderSFX.value) * 20;
        bool success = soundMixer.SetFloat("Sound Effects", volume);
        Debug.Log($"SetFloat success: {success}, volume sent: {volume}");
        soundMixer.GetFloat("Sound Effects", out var value);
        Debug.Log($"GetFloat returns: {value}");
    }
    
}
