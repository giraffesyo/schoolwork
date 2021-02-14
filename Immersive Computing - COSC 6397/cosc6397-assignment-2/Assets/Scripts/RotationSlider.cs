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
        this.models.GetCurrentModel().transform.Rotate(Vector3.right * delta * 360);
    }
}
