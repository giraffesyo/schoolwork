using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ModelManager : MonoBehaviour
{

    public int currentModel = 1;
    public List<GameObject> Models;

    public Button NextButton;
    public Button ContextButton;

    public GameObject GetCurrentModel()
    {
        return Models[currentModel];
    }

    private void Start()
    {
        NextButton.onClick.AddListener(NextModel);
        ContextButton.onClick.AddListener(ContextAction);

        for (int i = 0; i < transform.childCount; i++)
        {
            GameObject child = transform.GetChild(i).gameObject;
            Models.Add(child);
            if (i != 0)
            {
                child.SetActive(false);
            }
        }
        SetButtonText();
    }

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

    public void NextModel()
    {

        Models[currentModel].SetActive(false);
        currentModel = currentModel == Models.Count - 1 ? 0 : currentModel + 1;
        SetButtonText();
        if (Models[currentModel].name == "chalice")
        {
            Models[currentModel].GetComponent<Shatter>().unshatter();
        }
        Models[currentModel].SetActive(true);
    }


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
