using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoalUI : MonoBehaviour
{
    [SerializeField] private SO_CoalData coalData;
    [SerializeField] private GameObject coalQTEVisualPrefab;
    private ButtonData[] _buttonDatas;
    private Transform _buttonDisplayParent;

    private void Start()
    {
        _buttonDisplayParent = GetComponentInChildren<HorizontalLayoutGroup>().transform;
    }

    private Sprite DisplayInputButton(string inputName)
    {
        foreach (InputData buttonInputData in coalData.PossibleInputs)
        {
            if (inputName == buttonInputData.InputName)
            {
                return buttonInputData.Sprite;
            }
        }
        return null;
    }

    public void CorrectButtonPressed(int index)
    {
        _buttonDatas[index].visualForButton.color = Color.green;
    }

    public void IncorrectButtonPressed(int index)
    {
        _buttonDatas[index].visualForButton.color = Color.red;
    }

    public void HideUI()
    {
        foreach (Transform child in _buttonDisplayParent)
        {
            Destroy(child.gameObject);
        }

        _buttonDatas = null;

    }

    public void DisplayPasswordVisuals(string[] password)
    {
        _buttonDatas = new ButtonData[password.Length];
        for (int i = 0; i < password.Length; i++)
        {
           GameObject button = Instantiate(coalQTEVisualPrefab, GetComponentInChildren<HorizontalLayoutGroup>().transform);
           Debug.Log(button);
           _buttonDatas[i].visualForButton = button.GetComponent<Image>();
           _buttonDatas[i].visualForButton.sprite = DisplayInputButton(password[i]);
           
        }
    }
    
    struct ButtonData
    {
        public Image visualForButton;
    }
}
