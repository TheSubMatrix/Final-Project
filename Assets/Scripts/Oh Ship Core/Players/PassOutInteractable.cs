using UnityEngine;
using UnityEngine.Serialization;
using UnityEngine.UI;

public class PassOutInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private Transform _interactDisplayTransform;
    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    
    private HungerAndThirst _hungerNThirst;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Start()
    {
        _hungerNThirst = GetComponent<HungerAndThirst>();
        Debug.Log(_hungerNThirst);
    }
    
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = GetComponent<PlayerControlRouter>();
        _playerController = _playerControllable.GetActivePlayerController();
        
        if (_hungerNThirst.IsPassedOut)
        {
            Debug.Log("went through pass");
            m_currentInteractionSession = new InteractionSession(interactor, this);
            m_currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(_playerControllable);
            _hungerNThirst.WakeUp();
            return m_currentInteractionSession;
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
        return _interactDisplayTransform.position;
    }


}
