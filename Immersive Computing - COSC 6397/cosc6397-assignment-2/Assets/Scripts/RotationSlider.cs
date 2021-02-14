using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RotationSlider : SliderBase
{

    public GameObject gameobjectToRotate;
    public ModelManager models;
    override public void OnSliderChanged(float delta)
    {
        GameObject currentModel = this.models.GetCurrentModel();
        if (currentModel.name == "penny")
        {
            Debug.Log("rotating penny");
            this.models.transform.Rotate(Vector3.up * delta * 360);

        }
        else if (currentModel.name == "chalice")
        {
            this.models.transform.Rotate(Vector3.right * delta * 360);

        }
    }
}
