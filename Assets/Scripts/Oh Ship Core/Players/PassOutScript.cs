using UnityEngine;
using UnityEngine.UI;

public class PassOutScript : MonoBehaviour, IInteractable
{
    private GameObject canva;
    private Image fadeImage;
    private Color imageAlpha;
    InteractionSession m_currentInteractionSession;
    public bool isPassedOut = false;
    public bool wokeUp = false;


    // Start is called once before the first execution of Update after the MonoBehaviour is created
    void Awake()
    {
        fadeImage = GameObject.FindWithTag("PassingOut").GetComponent<Image>();
        //fadeImage = canva.GetComponent<Image>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void PassOut()
    {
        isPassedOut = true;
    }

    public void SlowDown()
    {
        //imageAlpha = fadeImage.color;
        //imageAlpha.a += Time.deltaTime/30;
        //fadeImage.color = imageAlpha;
    }

    void WakeUp()
    {
        wokeUp = true;
        isPassedOut = false;
        imageAlpha.a = 0;
        fadeImage.color = imageAlpha;

    }

    public InteractionSession BeginInteraction(IInteractor interactor)
    {
        if (interactor.IsInteracting() || m_currentInteractionSession is { IsActive: true }) return null;

        if(isPassedOut)
        {
            WakeUp();
            return m_currentInteractionSession;
        }
        return m_currentInteractionSession;
    }
}
