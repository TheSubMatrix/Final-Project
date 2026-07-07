using System;
using System.Collections;
using MatrixUtils.DependencyInjection;
using UnityEngine;

public class CuttingBoardInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private Transform _interactDisplayTransform;
    [SerializeField] private Transform storingLocation;

    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private PlayerInteractionState _playerInteractionState;
    private FoodClass _foodClassItem;
    private FoodClass currentFood;
    private Fish fish;
    private GameObject lastCookedObject;

    [Inject] INotificationMessenger m_notificationMessenger;

    private void Awake()
    {
        FindAnyObjectByType<Injector>().Inject(this);
    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();

        _playerController = _playerControllable.GetActivePlayerController();

        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();


        if (_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingCookedFish))
        {
            IHeldItemHandler handler = _playerControllable.GetAssociatedGameObject().GetComponentInChildren<IHeldItemHandler>();
            _foodClassItem = handler.HeldItem as FoodClass;
            Debug.Log($"<color=blue>FoodClassItem: {_foodClassItem} </color>");
            if (storingLocation.childCount == 0)
            {
                m_currentInteractionSession = new InteractionSession(interactor, this);
                m_currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(_playerControllable);
                handler.TryDropItem();

                MoveObjectToBoard();
                _playerInteractionState.RemoveInteractionTag(InteractionTag.HoldingCookedFish);
                _playerInteractionState.RemoveInteractionTag(InteractionTag.HoldingFish);
                m_currentInteractionSession.End();
                return m_currentInteractionSession;
            }
        }
        else
        {
            if (storingLocation.childCount > 0)
            {
                MoveObjetToHand();
                m_currentInteractionSession = new InteractionSession(interactor, this);
                m_currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(_playerControllable);
                _playerInteractionState.AddInteractionTag(InteractionTag.HoldingCookedFish);
                m_currentInteractionSession.End();
                return m_currentInteractionSession;
            }
        }

        m_currentInteractionSession = new InteractionSession(interactor, this);
        m_currentInteractionSession.End();

        StartCoroutine(DisplayWarning());
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

    private void MoveObjectToBoard()
    {
        _foodClassItem.transform.position = storingLocation.position;
        _foodClassItem.transform.SetParent(storingLocation);
        if (_foodClassItem.GetComponentInChildren<Fish>())
        {
            //Why are you hardcoding this?
            _foodClassItem.transform.localRotation = Quaternion.Euler(1.2f, 88.7f, 91.4f);
        }
        else if (_foodClassItem.GetComponentInChildren<Crab>())
        {
            _foodClassItem.transform.localRotation = Quaternion.Euler(186.8f, 181.7f, 3.2f);
        }
        Debug.Log("foodclass:" + _foodClassItem.transform.position);
    }


    private void MoveObjetToHand()
    {
        FoodClass cookingItem = storingLocation.GetComponentInChildren<FoodClass>();
        Debug.Log("cookingItem:" + cookingItem);
        if(_playerControllable.GetAssociatedGameObject().GetComponentInChildren<IHeldItemHandler>() is not {} handler){ Debug.LogError("No handler found"); return; }

        if (!handler.TryHoldItem(cookingItem))
        {
            Debug.LogWarning("Player's hands were already full, could not pick up from board.");
            return;
        }

        cookingItem.InitializeHungerAndThirst(_playerControllable.GetAssociatedGameObject().GetComponentInChildren<HungerAndThirst>());
    }
    
    IEnumerator DisplayWarning()
    {
        Debug.Log("Warning Label");
        int playerIndex = _playerInteractionState.PlayerIndex;
        Debug.Log($"Firing: 'enable cooked player{playerIndex}'");
        Debug.Log(m_notificationMessenger);
        m_notificationMessenger.TryNotify($"enable cooked player{playerIndex}");
        yield return new WaitForSeconds(3f);
        m_notificationMessenger.TryNotify($"disable cooked player{playerIndex}");;
    }
}