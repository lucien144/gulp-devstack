// Generated at: {{date}}
{{#shapes}}
{{#selector.dimensions}}{{expression}}{{^last}},
{{/last}}{{/selector.dimensions}} {
	width: 100%;
	height: 100%;
}
@svg-{{base}}-dims-width: {{width.outer}}px;
@svg-{{base}}-dims-height: {{height.outer}}px;
@svg-{{base}}-dims-ratio: {{height.outer}} / {{width.outer}};
{{/shapes}}