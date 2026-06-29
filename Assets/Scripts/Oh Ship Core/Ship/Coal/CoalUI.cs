using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CoalUI : MonoBehaviour
{
    [SerializeField] private SO_CoalData coalData;
    [SerializeField] private GameObject coalQTEVisualPrefab;
    private ButtonData[] _buttonVisuals;
    private ButtonData[] _buttonOutlines;
    private Transform _buttonDisplayParent;
    [SerializeField] private float _width = 64/2;
    [SerializeField] private float _height = 64/2;

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
        _buttonOutlines[index].visualForButton.color = Color.green;
    }

    public void IncorrectButtonPressed(int index)
    {
        _buttonOutlines[index].visualForButton.color = Color.red;
    }

    public void HideUI()
    {
        foreach (Transform child in _buttonDisplayParent)
        {
            Destroy(child.gameObject);
        }

        _buttonVisuals = null;

    }

    public void DisplayPasswordVisuals(string[] password)
    {
        _buttonVisuals = new ButtonData[password.Length];
        _buttonOutlines = new ButtonData[password.Length];
        for (int i = 0; i < password.Length; i++)
        {
           GameObject button = Instantiate(coalQTEVisualPrefab, GetComponentInChildren<HorizontalLayoutGroup>().transform);
           Debug.Log(button.transform.GetChild(0).name);
         
           _buttonVisuals[i].visualForButton = button.transform.GetChild(0).GetComponent<Image>();
           _buttonOutlines[i].visualForButton = button.GetComponent<Image>();
           _buttonVisuals[i].visualForButton.sprite = DisplayInputButton(password[i]);
           _buttonVisuals[i].visualForButton.rectTransform.sizeDelta = new Vector2(_width, _height);

        }
    }
    
    struct ButtonData
    {
        public Image visualForButton;
    }
}
