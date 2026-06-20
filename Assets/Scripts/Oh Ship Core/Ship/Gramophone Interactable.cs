using UnityEngine;
[RequireComponent(typeof(AudioSource))]
public class GramophoneInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    int m_currentTrack = 0;
    [SerializeField] AudioClip[] m_gramophoneTracks;
    [SerializeField] Transform m_interactDisplayTransform;
    [SerializeField] string m_widgetForPrompt = "interact";
    AudioSource m_audioSource;
    void Start()
    {
        m_audioSource = GetComponent<AudioSource>();
        if (m_gramophoneTracks.Length > 0)
        {
            m_audioSource.clip = m_gramophoneTracks[m_currentTrack];
            m_audioSource.Play();
        }
        else
        {
            m_currentTrack = -1;
        }
    }
    
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        SwapTrack();
        return null;
    }

    public PromptData GetPromptData() => new() {AssociatedWidget = m_widgetForPrompt};

    public Vector3 GetWidgetWorldPosition() => m_interactDisplayTransform.position;

    void SwapTrack()
    {
        if(m_currentTrack < m_gramophoneTracks.Length - 1) m_currentTrack++;
        else m_currentTrack = -1;
        if(m_currentTrack == -1) m_audioSource.Stop();
        else
        {
            m_audioSource.clip = m_gramophoneTracks[m_currentTrack];
            m_audioSource.Play();
        }
        
    }
}
