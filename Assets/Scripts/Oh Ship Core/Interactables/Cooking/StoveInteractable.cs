using UnityEngine;
using UnityEngine.InputSystem;

public class StoveInteractable : MonoBehaviour, IInteractable
{
    InteractionSession m_currentInteractionSession;
    [SerializeField] private GameObject fishToCook;
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
        if (interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;

        if(fishToCook.gameObject.activeSelf == true)
        {
            return null;
        }
        else
        {
            fishToCook.SetActive(true);
        }
        return m_currentInteractionSession;
    }
}
