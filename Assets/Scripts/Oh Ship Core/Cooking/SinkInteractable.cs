using System;
using System.Collections;
using System.Threading;
using UnityEngine;

public class SinkInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private Transform _interactDisplayTransform;

    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private PlayerInteractionState _playerInteractionState;
    public Animator animSink;

    [SerializeField] HungerAndThirst thirstManager;
    //[SerializeField] StatusBar m_thirstBar;

    private bool fillingUp = false;
    private bool drinking = false;
    [SerializeField] private float drinkingRate = 0.4f;
    [SerializeField] private float cooldown = 3.0f;
    private float timer = 0f;
    private float amountOfWater = 0f;
    private bool canInteract = true;
    private bool filledUp = false;

    private IPlayerControllable _playerControllableForHoldingObject;
    private Transform _holdingObjectTransform;
    private GameObject heldObject;
    [SerializeField] private GameObject bottleToSpawn;
    [SerializeField] private GameObject bottleInSink;
    [SerializeField] private GameObject bottleBack;
    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        timer = timer += 1 * Time.deltaTime;

        if(timer >= cooldown)
        {
            canInteract = true;
        }
        if(fillingUp)
        {
            if(!animSink.GetBool("waterRunning"))
            {
                animSink.SetBool("waterRunning", true);
            }
            amountOfWater = amountOfWater += 0.1f * Time.deltaTime;
        }

        if(amountOfWater >= 1f)
        {

            timer = 0f;
            canInteract = false;
            fillingUp = false;
            animSink.SetBool("waterRunning", false);
            filledUp = true;
        }
    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        thirstManager = _playerControllable.GetAssociatedGameObject().GetComponent<HungerAndThirst>();

        IPlayerControllable oldControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        IPlayerController controller = oldControllable.GetActivePlayerController();
        _playerControllableForHoldingObject = oldControllable;

        _playerController = _playerControllable.GetActivePlayerController();

        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();

        if (_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingFish))
        {
            return null;
        }
        else if(_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingBottle))
        {
            _playerInteractionState.RemoveInteractionTag(InteractionTag.HoldingBottle);
            if (animSink.GetBool("waterRunning"))
            {
                timer = 0f;
                canInteract = false;
                fillingUp = false;
                bottleInSink.SetActive(false);
                animSink.SetBool("waterRunning", false);
            }
        }
        else if (!filledUp)
        {
            bottleInSink.SetActive(true);
            _holdingObjectTransform = _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
            heldObject = _holdingObjectTransform.gameObject;
            Destroy(heldObject);
            timer = 0f;
            fillingUp = true;
            m_currentInteractionSession.End();
        }
        else if (filledUp)
        {
            DrinkWater(amountOfWater);
            bottleInSink.SetActive(false);
            bottleBack.SetActive(true);
            filledUp = false;
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

    void DrinkWater(float toDrink)
    {
        thirstManager.Thirst.Value += toDrink;
    }
}
