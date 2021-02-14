using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RotationSlider : SliderBase
{

    public GameObject gameobjectToRotate;
    override public void OnSliderChanged(float delta)
    {
        this.gameobjectToRotate.transform.Rotate(Vector3.right * delta * 360);
    }
}
