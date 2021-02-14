using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ModelManager : MonoBehaviour
{


    public int currentModel = 0;
    public List<GameObject> Models;
    public GameObject GetCurrentModel()
    {
        return Models[currentModel];
    }

    private void Start()
    {
        for (int i = 0; i < transform.childCount; i++)
        {
            GameObject child = transform.GetChild(i).gameObject;
            Models.Add(child);
            if (i != 0)
            {
                child.SetActive(false);
            }
        }
    }
    public void NextModel()
    {
        Models[currentModel].SetActive(false);
        currentModel = currentModel == Models.Count - 1 ? 0 : currentModel + 1;
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
            Debug.Log("hello chalice");
            Models[currentModel].GetComponent<Shatter>().shatter();

        }
    }




}
