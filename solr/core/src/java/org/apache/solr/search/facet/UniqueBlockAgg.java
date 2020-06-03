/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.solr.search.facet;

import java.io.IOException;
import java.util.Arrays;

import org.apache.lucene.index.MultiDocValues;
import org.apache.solr.schema.SchemaField;

/**
 * @author munendrasn
 */
public abstract class UniqueBlockAgg extends UniqueAgg {

  private final static String uniqueBlock = "uniqueBlock";

  protected static class UniqueBlockSlotAcc extends UniqueSinglevaluedSlotAcc {

    protected int[] lastSeenValuesPerSlot;

    public UniqueBlockSlotAcc(FacetContext fcontext, SchemaField field, int numSlots) throws IOException {
      super(fcontext, field, 0, null);
      counts = new int[numSlots];
      lastSeenValuesPerSlot = new int[numSlots];
      Arrays.fill(lastSeenValuesPerSlot, Integer.MIN_VALUE);
    }

    @Override
    protected void collectOrdToSlot(int slotNum, int ord) {
      if (lastSeenValuesPerSlot[slotNum]!=ord) {
        counts[slotNum]+=1;
        lastSeenValuesPerSlot[slotNum] = ord;
      }
    }

    @Override
    public void reset() throws IOException {
      // copying this to so that super.reset() is not called
      // as it sets counts to null
      topLevel = FieldUtil.getSortedDocValues(fcontext.qcontext, field, null);
      nTerms = topLevel.getValueCount();
      if (topLevel instanceof MultiDocValues.MultiSortedDocValues) {
        ordMap = ((MultiDocValues.MultiSortedDocValues)topLevel).mapping;
        subDvs = ((MultiDocValues.MultiSortedDocValues)topLevel).values;
      } else {
        ordMap = null;
        subDvs = null;
      }
      Arrays.fill(counts, 0);
      Arrays.fill(lastSeenValuesPerSlot, Integer.MIN_VALUE);
    }

    @Override
    public void calcCounts() {
      // noop already done
    }

    @Override
    public Object getValue(int slot) throws IOException {
      return counts[slot];
    }

    @Override
    public void resize(Resizer resizer) {
      lastSeenValuesPerSlot = resizer.resize(lastSeenValuesPerSlot, Integer.MIN_VALUE);
      super.resize(resizer);
    }
  }

  public UniqueBlockAgg(String field) {
    super(field);
    name = uniqueBlock;
  }

  @Override
  public abstract SlotAcc createSlotAcc(FacetContext fcontext, int numDocs, int numSlots) throws IOException;

  @Override
  public FacetMerger createFacetMerger(Object prototype) {
    return new FacetLongMerger() ;
  }
}
