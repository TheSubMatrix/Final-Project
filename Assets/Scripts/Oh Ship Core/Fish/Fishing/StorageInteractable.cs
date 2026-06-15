using System.Collections.Generic;
using UnityEngine;

public class StorageInteractable : MonoBehaviour, IInteractable
{
    private IPlayerControllable _playerControllable;
    private IPlayerController _playerController;
    private Transform _holdingObjectTransform;
    InteractionSession m_currentInteractionSession;
    public List<GameObject> _storedFish = new List<GameObject>();
    
    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        if (_storedFish.Count == 0)
        {
            Debug.Log("Need fish in container");
            m_currentInteractionSession = new InteractionSession(interactor,this);
            m_currentInteractionSession.End();
            return m_currentInteractionSession;
        }
        _playerControllable = interactor.GetAssociatedGameObject().transform.parent.GetComponent<IPlayerControllable>();
        Debug.Log(_playerControllable);
        _playerController = _playerControllable.GetActivePlayerController();
        
        m_currentInteractionSession = new InteractionSession(interactor, this);
        
        RemoveFishFromStorage(_storedFish[0]);
        
        return m_currentInteractionSession;
    }
    
    public void AddFishToStorage(GameObject fish)
    {
        _storedFish.Add(fish);
    }

    public void RemoveFishFromStorage(GameObject fishRef)
    {
        _storedFish.Remove(fishRef);
        _holdingObjectTransform =  _playerControllable.GetAssociatedGameObject().GetComponentInChildren<HeldObjectLocation>().transform;
        GameObject fish = Instantiate(fishRef, _holdingObjectTransform.position,_holdingObjectTransform.rotation);
        fish.transform.SetParent(_holdingObjectTransform);
    }
}
