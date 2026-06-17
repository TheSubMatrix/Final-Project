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
    
    [SerializeField] StatusBarManager status;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
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

        status = _playerController.GetAssociatedGameObject().transform.root.GetComponentInChildren<StatusBarManager>();

        Debug.Log("passed: " + status.isPassedOut);

        Debug.Log("interactor: " + interactor.IsInteracting());

        if (status.isPassedOut)
        {
            m_currentInteractionSession = new InteractionSession(interactor, this);
            m_currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(_playerControllable);
            status.WakeUp();
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
