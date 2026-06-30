using System.Collections.Generic;
using UnityEngine;

public class StorageInteractable : MonoBehaviour, IInteractable, IPromptProvider
{
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private Transform _holdingObjectTransform;
    InteractionSession m_currentInteractionSession;
    [SerializeField] private List<SO_CookableFoodData> _storedWaterLife =  new List<SO_CookableFoodData>();
    [SerializeField] private string _widgetForPrompt = "interact";
    [SerializeField] private int maxStoredFish = 5;
    private PlayerInteractionState _playerInteractionState;
    
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
       
        _playerController = _playerControllable.GetActivePlayerController();
        
        _playerInteractionState = _playerControllable.GetAssociatedGameObject().GetComponent<PlayerInteractionState>();
        
        if (_storedWaterLife.Count < maxStoredFish && _playerInteractionState.CheckInteractionTag(InteractionTag.HoldingFish))
        {
            if (_playerControllable.GetAssociatedGameObject().GetComponentInChildren<FoodClass>().CookStateRef != CookState.Raw)
            {
                return null;
            }
            _holdingObjectTransform =  _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
            AddFishToStorage(_playerControllable.GetAssociatedGameObject().GetComponentInChildren<FoodClass>().FoodData);
            Destroy(_holdingObjectTransform.GetChild(0).gameObject);
            m_currentInteractionSession = new InteractionSession(interactor,this);
            _playerInteractionState.RemoveInteractionTag(InteractionTag.HoldingFish);
            m_currentInteractionSession.End();
            return m_currentInteractionSession;
        }

        if (_storedWaterLife.Count == 0)
        {
            m_currentInteractionSession = new InteractionSession(interactor, this);
            m_currentInteractionSession.End();
            return m_currentInteractionSession;
        }
        m_currentInteractionSession = new InteractionSession(interactor, this);
        
        RemoveFishFromStorage(_storedWaterLife[0]);
        
        return m_currentInteractionSession;
    }
    
    public void AddFishToStorage(SO_CookableFoodData foodData)
    {
        _storedWaterLife.Add(foodData);
    }

    public void RemoveFishFromStorage(SO_CookableFoodData foodData)
    {
        HungerAndThirst hungerRef = _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HungerAndThirst>();
        _holdingObjectTransform =  _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
        GameObject fish = Instantiate(foodData.Model, _holdingObjectTransform.position,_holdingObjectTransform.rotation);
        fish.transform.SetParent(_holdingObjectTransform);
        fish.GetComponent<FoodClass>().InitializeHungerAndThirst(hungerRef);
        _playerInteractionState.AddInteractionTag(InteractionTag.HoldingFish);
        _storedWaterLife.RemoveAt(0);
    }


    public PromptData GetPromptData()
    {
        return new PromptData() { AssociatedWidget = _widgetForPrompt, };
    }

    public Vector3 GetWidgetWorldPosition()
    {
        return transform.position;
    }
}
