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

    private IPlayerControllable _playerControllableForHoldingObject;
    private Transform _holdingObjectTransform;
    private GameObject heldObject;
    [SerializeField] private GameObject bottleToSpawn;
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
        if(drinking)
        {
            DrinkWater();
        }
        if(fillingUp)
        {
            if(!animSink.GetBool("waterRunning"))
            {
                StartCoroutine(FillUpBottle());
            }
            amountOfWater = amountOfWater += 0.1f * Time.deltaTime;
        }

        if(amountOfWater >= 1f)
        {
            fillingUp = false;
            animSink.SetBool("waterRunning", false);
            _playerInteractionState.AddInteractionTag(InteractionTag.HoldingBottleWithWater);
            _holdingObjectTransform = _playerControllableForHoldingObject.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
            GameObject bottle = Instantiate(bottleToSpawn, _holdingObjectTransform.position, _holdingObjectTransform.rotation);
            bottle.transform.SetParent(_holdingObjectTransform);
        }
    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        thirstManager = _playerControllable.GetAssociatedGameObject().GetComponent<HungerAndThirst>();

        _playerController = _playerControllable.GetActivePlayerController();

        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();

        if (_playerInteractionState.CheckInteractionTag(InteractionTag.HoldingFish) || _playerInteractionState.CheckInteractionTag(InteractionTag.HoldingBottleWithWater))
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
                animSink.SetBool("waterRunning", false);
            }
            else
            {
                _holdingObjectTransform = _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
                heldObject = _holdingObjectTransform.gameObject;
                Destroy(heldObject);
                timer = 0f;
                fillingUp = true;
            }
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

    void DrinkWater()
    {
        thirstManager.Thirst.Value += drinkingRate * Time.deltaTime;
    }

    private IEnumerator FillUpBottle()
    {
        animSink.SetBool("waterRunning", true);
        yield return new WaitForSeconds(4);
    }
}
