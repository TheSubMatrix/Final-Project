using MatrixUtils.Extensions;
using UnityEngine;
using UnityEngine.Audio;

public class EngineSoundController : MonoBehaviour
{
    [SerializeField] float m_minPitch;
    [SerializeField] float m_maxPitch;
    [SerializeField] AudioMixer m_engineHighMixer;
    
    public void HandleEngineSoundAdjustments(float value)
    {
        m_engineHighMixer.SetFloat("Engine Pitch", Mathf.Abs(value).Remap(0, 1, m_minPitch, m_maxPitch));
    }
}
