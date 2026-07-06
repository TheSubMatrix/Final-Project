using System;
using MatrixUtils.Attributes;
using UnityEngine;
using UnityEngine.InputSystem;

/// <summary>
/// Handles interactions with <see cref="IInteractable"/> by the player.
/// </summary>
public class PlayerInteractor : MonoBehaviour, IInteractor
{
    /// <summary>
    /// The range in which the player can interact with an <see cref="IInteractable"/>
    /// </summary>
    [SerializeField] float m_interactionRange = 2;
    [SerializeField] LayerMask m_interactionLayer;
    InteractionSession m_session;
    [SerializeField, RequiredField]HeldObjectLocation m_heldObjectLocation;
    [SerializeField] PlayerInteractionState m_playerState;
    
    /// <inheritdoc/>
    public bool IsInteracting() => m_session?.IsActive is true;
    /// <inheritdoc/>
    public InteractionSession GetSession() => m_session;

    //This should not be in here. This should be handled by the interactable calling to the audio manager
    [Header("Sound")]
    [SerializeField] private AudioSource audioSource;
    [SerializeField] private AudioClip chewing;
    [SerializeField] private AudioClip drinking;

    public bool feeding = false;
    
    /// <inheritdoc/>
    public bool RequestSessionTransfer(InteractionSession session)
    {
        if (IsInteracting() || !session.TransferTo(this)) return false;
        m_session = session;
        SubscribeToSession();
        return true;
    }
    /// <inheritdoc/>
    public GameObject GetAssociatedGameObject() => gameObject;

    /// <summary>
    /// Attempts to begin an interaction with the nearest <see cref="IInteractable"/> in the <see cref="m_interactionRange"/>
    /// </summary>
    public void OnInteractionButtonPressed()
    {
        LayerMask playerLayer = 1 << transform.parent.gameObject.layer;
        //Debug.Log($"Player layer: {transform.parent.gameObject.layer}, Default mask: {LayerMask.GetMask("Default")}, blocked: {playerLayer == LayerMask.GetMask("Default")}");

        if (playerLayer == LayerMask.GetMask("Default")) return;
        if (IsInteracting())
        {
            if (Physics.Raycast(transform.position, transform.forward, out RaycastHit checkHit, m_interactionRange, m_interactionLayer)
                && checkHit.collider.TryGetComponent(out IInteractable checkInteractable))
            {
                InteractionSession newSession = checkInteractable.BeginInteraction(this);
                if (newSession is null) return;
                EndActiveInteraction();
                m_session = newSession;
                if (m_session is { IsActive: true }) SubscribeToSession();
                return;
            }
            EndActiveInteraction();
            return;
        }

        if (!Physics.Raycast(transform.position, transform.forward, out RaycastHit hit, m_interactionRange, m_interactionLayer)) return;
        if (!hit.collider.TryGetComponent(out IInteractable interactable)) return;
        m_session = interactable.BeginInteraction(this);

        if (m_session is not { IsActive: true }) return;
        SubscribeToSession();
    }
    
    void SubscribeToSession()
    {
        m_session.OnEnded +=  () => m_session = null;
        m_session.OnTransferred += (old, _) =>
        {
            if (!ReferenceEquals(old, this)) return;
            m_session = null;
        };
    }
    /// <summary>
    /// Ends the current <see cref="InteractionSession"/> if one exists.
    /// </summary>
    public void EndActiveInteraction()
    {
        if (!IsInteracting()) return;
        InteractionSession session = m_session;
        m_session = null;
        session.End();
    }
    void OnDisable() => EndActiveInteraction();
    
    private void Start()
    {
        m_heldObjectLocation ??= GetComponentInChildren<HeldObjectLocation>();
        //Why do this here?
        Cursor.visible = false;
        Cursor.lockState = CursorLockMode.Locked;
    }
    //Encapsulate this functionality to the held items, this doesn't belong in the interactor
    public void UseHeldItem()
    {
        LayerMask playerLayer = 1 << transform.parent.gameObject.layer;
        if (playerLayer == LayerMask.GetMask("Default")) return;
        IUsableItem usableItem = m_heldObjectLocation.GetComponentInChildren<IUsableItem>();
        // This is awful for expansion and why the data should be encapsulated in the IUsableItem as Logan set up
        if (usableItem != null)
        {
            usableItem.Use();
            if (m_playerState.CheckInteractionTag(InteractionTag.HoldingFish) || m_playerState.CheckInteractionTag(InteractionTag.HoldingCookedFish) || m_playerState.CheckInteractionTag(InteractionTag.HoldingBurntFish))
            {
                audioSource.clip = chewing;
                audioSource.PlayOneShot(chewing);
                m_playerState.RemoveInteractionTag(InteractionTag.HoldingFish);
                Debug.Log("eats");
            }
            else if(m_playerState.CheckInteractionTag(InteractionTag.HoldingBottleWithWater) && !feeding)
            {
                Debug.Log("plays");
                audioSource.clip = drinking;
                audioSource.PlayOneShot(drinking);
                m_playerState.RemoveInteractionTag(InteractionTag.HoldingBottleWithWater);
            }
            feeding = false;
            Debug.Log("Using holding");
        }
    }
    
}