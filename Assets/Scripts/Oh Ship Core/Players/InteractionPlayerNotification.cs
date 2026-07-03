using MatrixUtils.DependencyInjection;
using UnityEngine;

public class InteractionPlayerNotification : MonoBehaviour
{
    [Inject] INotificationMessenger m_notificationMessenger;
    [SerializeField] private GameObject m_hoop;
    [SerializeField] private string[] m_displayNotification;
    [SerializeField] private string[] m_hideNotification;
    void Start()
    {
        FindAnyObjectByType<Injector>().Inject(this);
        m_hoop.SetActive(false);

        foreach (string s in m_displayNotification)
        {
            m_notificationMessenger.TrySubscribe(s, ()=> m_hoop.SetActive(true));
        }
       
        foreach (string s in m_hideNotification)
        {
            m_notificationMessenger.TrySubscribe(s, ()=> m_hoop.SetActive(false));
        }
       
    }
    
}
