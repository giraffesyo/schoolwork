using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SizeSlider : SliderBase
{
    public GameObject gameObjectToResize;
    override public void OnSliderChanged(float delta)
    {
        Vector3 scale = new Vector3(transform.localScale.x * delta, transform.localScale.y * delta, transform.localScale.z * delta);
        this.gameObjectToResize.transform.localScale = scale;
    }
}
