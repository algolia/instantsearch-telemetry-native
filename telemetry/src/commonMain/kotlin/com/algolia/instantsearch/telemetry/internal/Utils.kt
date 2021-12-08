package com.algolia.instantsearch.telemetry.internal

import com.algolia.instantsearch.telemetry.Component
import com.algolia.instantsearch.telemetry.Schema

private fun <T> Set<T>.merge(set: Set<T>) = this + set
