using Unity.Cinemachine;
using UnityEngine;
using UnityEngine.InputSystem;

public class StoveInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private GameObject fishToCook;
    [SerializeField] private Transform _interactDisplayTransform;
    private readonly string _widgetForPrompt = "interact";
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private PlayerInteractionState _playerInteractionState;
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
       
        _playerController = _playerControllable.GetActivePlayerController();
        
        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();

        if (_playerInteractionState.CheckInteractionTag(InteractionTag.Holding))
        {
            m_currentInteractionSession = new InteractionSession(interactor, this);
            m_currentInteractionSession.OnEnded += () => _playerController.ChangeControlledEntity(_playerControllable);
            DestroyFishInHand();
            fishToCook.SetActive(true);
            _playerInteractionState.RemoveInteractionTag(InteractionTag.Holding);
            Debug.Log("Removed Holding");
            m_currentInteractionSession.End();
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

    private void DestroyFishInHand()
    {
        GameObject player = _playerControllable.GetAssociatedGameObject();
        HeldObjectLocation heldObjectLocation = player.GetComponentInChildren<HeldObjectLocation>();
        heldObjectLocation.DestroyObjectsInHand();
    }
}
