using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;

public class GameOverScreen : MonoBehaviour
{
    [SerializeField] private GameObject m_firstSelectedButton;
    void Start()
    {
        if(m_firstSelectedButton != null)
        {
            Debug.Log("Force set");
            EventSystem.current.SetSelectedGameObject(m_firstSelectedButton);
        }
    }

   
}
