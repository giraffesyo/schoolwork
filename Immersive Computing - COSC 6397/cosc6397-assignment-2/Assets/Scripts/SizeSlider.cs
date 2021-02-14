using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SizeSlider : SliderBase
{
    public ModelSwitcher models;
    override public void OnSliderChanged(float delta)
    {
        Vector3 scale = new Vector3(transform.localScale.x * delta, transform.localScale.y * delta, transform.localScale.z * delta);
        this.models.transform.localScale = scale;
    }
}
