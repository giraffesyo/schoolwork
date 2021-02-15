using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


static class ModelNames
{
    public const string AANG = "aang";
    public const string CHALICE = "chalice";
    public const string PENNY = "penny";
}

static class ButtonTexts
{
    public const string SHATTER = "Shatter";
    public const string WOOPS = "woops";
    public const string FLIP = "Flip";
    public const string WAVE = "Wave";
}

public class ModelManager : MonoBehaviour
{

    public int currentModel = 0;
    public List<GameObject> Models;

    public Button NextButton;
    public Button ContextButton;

    public GameObject GetCurrentModel()
    {
        return Models[currentModel];
    }


    private void Start()
    {
        // Add event listeners to the buttons
        NextButton.onClick.AddListener(NextModel);
        ContextButton.onClick.AddListener(ContextAction);

        // Loop through all children, adding them to list for later use
        for (int i = 0; i < transform.childCount; i++)
        {
            GameObject child = transform.GetChild(i).gameObject;
            Models.Add(child);
            if (i != 0)
            {
                // Disable all other models besides first one in list
                child.SetActive(false);
            }
        }
        SetButtonText();
    }

    // Sets the context button initial text based on current model name
    private void SetButtonText()
    {
        Text btnText = ContextButton.GetComponentInChildren<Text>();
        string name = Models[currentModel].name;
        if (name == ModelNames.PENNY)
        {
            ContextButton.gameObject.SetActive(true);
            btnText.text = ButtonTexts.FLIP;
        }
        else if (name == ModelNames.CHALICE)
        {
            ContextButton.gameObject.SetActive(true);
            btnText.text = ButtonTexts.SHATTER;
        }
        else if (name == ModelNames.AANG)
        {
            ContextButton.gameObject.SetActive(true);
            btnText.text = ButtonTexts.WAVE;
        }
        else
        {
            // hide the button if the model isnt one of the above (won't happen in current setup without adding more models)
            ContextButton.gameObject.SetActive(false);
        }
    }
    // Switches out the current model shown, and handles any cleanup that might need to be done when switching
    public void NextModel()
    {

        Models[currentModel].SetActive(false);
        currentModel = currentModel == Models.Count - 1 ? 0 : currentModel + 1;
        SetButtonText();
        Models[currentModel].SetActive(true);
        if (Models[currentModel].name == ModelNames.CHALICE)
        {
            Models[currentModel].GetComponent<Shatter>().unshatter();
        }

    }

    // Handles performing actions that are specific to each model
    public void ContextAction()
    {

        if (Models[currentModel].name == ModelNames.PENNY)
        {
            // play spin animation
            GetCurrentModel().GetComponent<Animator>().Play("flip");

        }
        else if (Models[currentModel].name == ModelNames.CHALICE)
        {
            Text contextText = ContextButton.GetComponentInChildren<Text>();
            bool shattered = Models[currentModel].GetComponent<Shatter>().shatter();
            if (shattered)
            {
                contextText.text = ButtonTexts.WOOPS;
            }
            else
            {
                contextText.text = ButtonTexts.SHATTER;
            }
        }
        else if (Models[currentModel].name == ModelNames.AANG)
        {

        }
    }




}
