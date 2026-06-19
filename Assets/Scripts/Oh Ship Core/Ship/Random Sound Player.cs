using System;
using System.Collections;
using MatrixUtils.AudioSystem;
using UnityEngine;

public class RandomSoundPlayer : MonoBehaviour
{
    [SerializeField] SoundData[] m_sounds;
    [SerializeField] float m_minDelay = 0.5f;
    [SerializeField] float m_maxDelay = 1f;
    [SerializeField] float m_minVolume = 0.5f;
    [SerializeField] float m_maxVolume = 1f;
    bool m_completed;
    
    void Start() => StartCoroutine(SoundLoop());
    void OnDestroy() => m_completed = true;
    IEnumerator SoundLoop()
    {
        while (!m_completed)
        {
            yield return new WaitForSeconds(UnityEngine.Random.Range(m_minDelay, m_maxDelay));
            if (m_completed || m_sounds.Length <= 0) yield break;
            SoundData randomSound = m_sounds[UnityEngine.Random.Range(0, m_sounds.Length)];
            SoundManager.Instance.CreateSound().WithRandomVolume(m_minVolume, m_maxVolume).WithRandomPitch().WithSoundData(randomSound).Play();
        }
    }
}
