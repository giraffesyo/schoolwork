using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

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
        if (name == "penny")
        {
            btnText.text = "Flip";
        }
        else if (name == "chalice")
        {
            btnText.text = "Shatter";
        }
    }
    // Switches out the current model shown, and handles any cleanup that might need to be done when switching
    public void NextModel()
    {

        Models[currentModel].SetActive(false);
        currentModel = currentModel == Models.Count - 1 ? 0 : currentModel + 1;
        SetButtonText();
        Models[currentModel].SetActive(true);
        if (Models[currentModel].name == "chalice")
        {
            Models[currentModel].GetComponent<Shatter>().unshatter();
        }

    }

    // Handles performing actions that are specific to each model
    public void ContextAction()
    {

        if (Models[currentModel].name == "penny")
        {
            // play spin animation
            GetCurrentModel().GetComponent<Animator>().Play("flip");

        }
        else if (Models[currentModel].name == "chalice")
        {
            Text contextText = ContextButton.GetComponentInChildren<Text>();
            bool shattered = Models[currentModel].GetComponent<Shatter>().shatter();
            if (shattered)
            {
                contextText.text = "woops";
            }
            else
            {
                contextText.text = "Shatter";
            }
        }
    }




}
