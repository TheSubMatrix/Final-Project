using UnityEngine;
using UnityEngine.Serialization;
public class BottleInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;

    [FormerlySerializedAs("_interactDisplayTransform")] [SerializeField]
    Transform m_interactDisplayTransform;

    const string WidgetForPrompt = "interact";
    IPlayerControllable m_playerControllable;
    PlayerInteractionState m_playerInteractionState;

    IPlayerControllable m_playerControllableForHoldingObject;
    IHeldItemHandler m_itemHoldingHandler;

    [FormerlySerializedAs("m_bottleToSpawn")] [FormerlySerializedAs("bottleToSpawn")] [SerializeField]
    InterfaceReference<IHeldItem> m_heldBottle;

    [SerializeField] private GameObject bottleTaken;

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        m_playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        m_playerInteractionState = m_playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();
        IPlayerControllable oldControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        m_playerControllableForHoldingObject = oldControllable;
        m_playerInteractionState = oldControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();
        if (m_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingFish) ||
            m_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingBottle) ||
            m_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingCookedFish))
        {
            return null;
        }

        m_playerInteractionState.AddInteractionTag(InteractionTag.HoldingBottle);
        m_itemHoldingHandler = m_playerControllableForHoldingObject.GetAssociatedGameObject().GetComponentInChildren<IHeldItemHandler>();
        IHeldItem bottle = Instantiate(m_heldBottle.Value.GetAssociatedGameObject()).GetComponent<IHeldItem>();
        m_itemHoldingHandler.TryHoldItem(bottle);
        gameObject.SetActive(false);
        m_currentInteractionSession = new(interactor, this);
        m_currentInteractionSession.End();

        return m_currentInteractionSession;
    }

    public PromptData GetPromptData() => new() { AssociatedWidget = WidgetForPrompt };

    public Vector3 GetWidgetWorldPosition() => !m_interactDisplayTransform ? transform.position : m_interactDisplayTransform.position;
}