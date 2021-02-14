using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SizeSlider : SliderBase
{
    public ModelManager models;
    override public void OnSliderChanged(float delta)
    {
        GameObject currentModel = this.models.GetCurrentModel();
        // get current global position of child
        Vector3 position = currentModel.transform.position;
        Vector3 scale = new Vector3(transform.localScale.x * delta, transform.localScale.y * delta, transform.localScale.z * delta);

        this.models.transform.localScale = scale;
        currentModel.transform.position = position;
    }
}
