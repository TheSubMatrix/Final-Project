using MatrixUtils.Attributes;
using MatrixUtils.AudioSystem;
using UnityEngine;
using UnityEngine.Events;

/// <summary>
/// Interacting with this object will move the <see cref="IInteractor"/> to the position specified in the inspector
/// </summary>
public class HatchInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    [SerializeReference, ClassSelector] PromptData m_promptData;
    [SerializeField] SoundData m_interactSound;
    [SerializeField] Transform m_widgetPosition;
    [SerializeField] Transform m_outPosition;
    [SerializeField] UnityEvent m_onInteract;
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        ITransitionHider transitionHider = interactor.GetAssociatedGameObject().transform.root.GetComponent<IPlayerControllable>().GetActivePlayerController().GetAssociatedGameObject().transform.root.GetComponentInChildren<ITransitionHider>();
        Rigidbody rb = interactor.GetAssociatedGameObject().transform.root.GetComponent<Rigidbody>();
        SoundManager.Instance.CreateSound().WithSoundData(m_interactSound).AttachedTo(transform).WithRandomPitch().Play();
        m_onInteract.Invoke();
        transitionHider.FadeIn(0.2f, () =>
        {
            rb.MovePosition(m_outPosition.position);
            transitionHider.FadeOut(0.2f);
        });
        return null;
    }

    public PromptData GetPromptData() => m_promptData;
    public Vector3 GetWidgetWorldPosition() => !m_widgetPosition? transform.position : m_widgetPosition.position;
}
