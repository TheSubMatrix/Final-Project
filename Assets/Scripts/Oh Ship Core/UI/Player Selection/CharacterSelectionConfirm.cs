using System;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Events;
public class CharacterSelectionConfirm : MonoBehaviour
{
    [SerializeField] Sprite[] m_playerConfirmImage;
    private Image m_image;
    public void OnSelected(int playerIndex)
    {
        GameObject[] cursors = GameObject.FindGameObjectsWithTag("Player Selection Cursor");
        
        if (playerIndex >= cursors.Length) return;
        m_image = cursors[playerIndex].GetComponent<Image>();
        
        m_image.sprite = m_playerConfirmImage[playerIndex];
        
        m_image.color = Color.green;


    }

    public void OnUnSelected(int playerIndex)
    {
        m_image.sprite = m_playerConfirmImage[playerIndex];
        m_image.color = Color.white;

    }
}
