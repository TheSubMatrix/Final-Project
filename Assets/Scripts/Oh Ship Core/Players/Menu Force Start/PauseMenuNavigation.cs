using UnityEngine;
using System.Collections.Generic;
using UnityEngine.UI;
public class PauseMenuNavigation : MonoBehaviour
{
    [SerializeField] private List<Button> m_buttons;
    private int m_currentButtonIndex = 0;
   
    public void OpenMenu()
    {
        m_currentButtonIndex = 0;
        UpdateButtonsVisuals();
    }

    public void MoveUp() => Move(-1);
    public void MoveDown() => Move(1);

    void Move(int direction)
    {
        m_currentButtonIndex = (m_currentButtonIndex + direction + m_buttons.Count) % m_buttons.Count;
        UpdateButtonsVisuals();
    }
    
    public void Confirm() => m_buttons[m_currentButtonIndex].onClick.Invoke();

    private void UpdateButtonsVisuals()
    {
        for (int i = 0; i < m_buttons.Count; i++)
        {
            ColorBlock colors = m_buttons[i].colors;
            m_buttons[i].GetComponent<Image>().color = i == m_currentButtonIndex ? colors.highlightedColor : colors.normalColor;
        }
    }
}
