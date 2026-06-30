using System;
using UnityEngine;
using UnityEngine.InputSystem;

public class BottleInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private Transform _interactDisplayTransform;

    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private PlayerInteractionState _playerInteractionState;

    private IPlayerControllable _playerControllableForHoldingObject;
    private Transform _holdingObjectTransform;
    [SerializeField] private GameObject bottleToSpawn;
    [SerializeField] private GameObject bottleTaken;

    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        _playerController = _playerControllable.GetActivePlayerController();
        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();

        IPlayerControllable oldControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        IPlayerController controller = oldControllable.GetActivePlayerController();
        _playerControllableForHoldingObject = oldControllable;
        _playerController = controller;
        _playerInteractionState = oldControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();

        if (_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingFish) || _playerInteractionState.CheckInteractionTag(InteractionTag.HoldingBottle) || _playerInteractionState.CheckInteractionTag(InteractionTag.HoldingCookedFish))
        {
            return null;
        }
        else
        {
            _playerInteractionState.AddInteractionTag(InteractionTag.HoldingBottle);
            _holdingObjectTransform = _playerControllableForHoldingObject.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
            GameObject bottle = Instantiate(bottleToSpawn, _holdingObjectTransform.position, _holdingObjectTransform.rotation);
            bottle.transform.SetParent(_holdingObjectTransform);
            gameObject.SetActive(false);
        }

        m_currentInteractionSession = new InteractionSession(interactor, this);
        m_currentInteractionSession.End();

        return m_currentInteractionSession;

    }

    public PromptData GetPromptData()
    {
        return new PromptData { AssociatedWidget = _widgetForPrompt };
    }

    public Vector3 GetWidgetWorldPosition()
    {
        return _interactDisplayTransform == null ? transform.position : _interactDisplayTransform.position;
    }
}
