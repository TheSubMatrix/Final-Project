using UnityEngine;
/// <summary>
/// Handles interactions with <see cref="IInteractable"/> by the player.
/// </summary>
public class PlayerInteractor : MonoBehaviour, IInteractor
{
    /// <summary>
    /// The range in which the player can interact with an <see cref="IInteractable"/>
    /// </summary>
    [SerializeField] float m_interactionRange = 2;
    InteractionSession m_session;
    /// <inheritdoc/>
    public bool IsInteracting() => m_session is { IsActive: true };
    /// <inheritdoc/>
    public InteractionSession GetSession() => m_session;
    /// <inheritdoc/>
    public void RequestSessionTransfer(InteractionSession session)
    {
        session.TransferTo(this);
        m_session = session;
    }
    /// <summary>
    /// Attempts to begin an interaction with the nearest <see cref="IInteractable"/> in the <see cref="m_interactionRange"/>
    /// </summary>
    public void OnInteraction()
    {
        if (IsInteracting()) return;
        if (!Physics.Raycast(transform.position, transform.forward, out RaycastHit hit, m_interactionRange)) return;
        if (!hit.collider.TryGetComponent(out IInteractable interactable)) return;
        m_session = interactable.BeginInteraction(this);
    }
    /// <summary>
    /// Ends the active <see cref="InteractionSession"/> handled by this <see cref="PlayerInteractor"/>
    /// </summary>
    public void OnInteractionEnd()
    {
        if (!IsInteracting()) return;
        m_session.Target.EndInteraction(m_session);
        m_session.End();
        m_session = null;
    }
    void OnDisable() => OnInteractionEnd();
}