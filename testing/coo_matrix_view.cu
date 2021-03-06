#include <unittest/unittest.h>

#include <cusp/coo_matrix.h>
#include <cusp/multiply.h>

template <typename MemorySpace>
void TestCooMatrixView(void)
{
  typedef int                                                           IndexType;
  typedef float                                                         ValueType;
  typedef typename cusp::coo_matrix<IndexType,ValueType,MemorySpace>    Matrix;
  typedef typename cusp::array1d<IndexType,MemorySpace>::iterator       IndexIterator;
  typedef typename cusp::array1d<ValueType,MemorySpace>::iterator       ValueIterator;
  typedef typename cusp::array1d_view<IndexIterator>                    IndexView;
  typedef typename cusp::array1d_view<ValueIterator>                    ValueView;
  typedef typename cusp::coo_matrix_view<IndexView,IndexView,ValueView> View;

  Matrix M(3, 2, 6);

  View V(3, 2, 6,
      cusp::make_array1d_view(M.row_indices.begin(),    M.row_indices.end()),
      cusp::make_array1d_view(M.column_indices.begin(), M.column_indices.end()),
      cusp::make_array1d_view(M.values.begin(),         M.values.end()));

  ASSERT_EQUAL(V.num_rows,    3);
  ASSERT_EQUAL(V.num_cols,    2);
  ASSERT_EQUAL(V.num_entries, 6);

  ASSERT_EQUAL_QUIET(V.row_indices.begin(),    M.row_indices.begin());
  ASSERT_EQUAL_QUIET(V.row_indices.end(),      M.row_indices.end());
  ASSERT_EQUAL_QUIET(V.column_indices.begin(), M.column_indices.begin());
  ASSERT_EQUAL_QUIET(V.column_indices.end(),   M.column_indices.end());
  ASSERT_EQUAL_QUIET(V.values.begin(),         M.values.begin());
  ASSERT_EQUAL_QUIET(V.values.end(),           M.values.end());
  
  View W(M);
  
  ASSERT_EQUAL(W.num_rows,    3);
  ASSERT_EQUAL(W.num_cols,    2);
  ASSERT_EQUAL(W.num_entries, 6);

  ASSERT_EQUAL_QUIET(W.row_indices.begin(),    M.row_indices.begin());
  ASSERT_EQUAL_QUIET(W.row_indices.end(),      M.row_indices.end());
  ASSERT_EQUAL_QUIET(W.column_indices.begin(), M.column_indices.begin());
  ASSERT_EQUAL_QUIET(W.column_indices.end(),   M.column_indices.end());
  ASSERT_EQUAL_QUIET(W.values.begin(),         M.values.begin());
  ASSERT_EQUAL_QUIET(W.values.end(),           M.values.end());
}
DECLARE_HOST_DEVICE_UNITTEST(TestCooMatrixView);


template <typename MemorySpace>
void TestCooMatrixViewAssignment(void)
{
  typedef int                                                           IndexType;
  typedef float                                                         ValueType;
  typedef typename cusp::coo_matrix<IndexType,ValueType,MemorySpace>    Matrix;
  typedef typename cusp::array1d<IndexType,MemorySpace>::iterator       IndexIterator;
  typedef typename cusp::array1d<ValueType,MemorySpace>::iterator       ValueIterator;
  typedef typename cusp::array1d_view<IndexIterator>                    IndexView;
  typedef typename cusp::array1d_view<ValueIterator>                    ValueView;
  typedef typename cusp::coo_matrix_view<IndexView,IndexView,ValueView> View;

  Matrix M(3, 2, 6);

  View V = M;

  ASSERT_EQUAL(V.num_rows,    3);
  ASSERT_EQUAL(V.num_cols,    2);
  ASSERT_EQUAL(V.num_entries, 6);

  ASSERT_EQUAL_QUIET(V.row_indices.begin(),    M.row_indices.begin());
  ASSERT_EQUAL_QUIET(V.row_indices.end(),      M.row_indices.end());
  ASSERT_EQUAL_QUIET(V.column_indices.begin(), M.column_indices.begin());
  ASSERT_EQUAL_QUIET(V.column_indices.end(),   M.column_indices.end());
  ASSERT_EQUAL_QUIET(V.values.begin(),         M.values.begin());
  ASSERT_EQUAL_QUIET(V.values.end(),           M.values.end());

  View W = V;
  
  ASSERT_EQUAL(W.num_rows,    3);
  ASSERT_EQUAL(W.num_cols,    2);
  ASSERT_EQUAL(W.num_entries, 6);

  ASSERT_EQUAL_QUIET(W.row_indices.begin(),    M.row_indices.begin());
  ASSERT_EQUAL_QUIET(W.row_indices.end(),      M.row_indices.end());
  ASSERT_EQUAL_QUIET(W.column_indices.begin(), M.column_indices.begin());
  ASSERT_EQUAL_QUIET(W.column_indices.end(),   M.column_indices.end());
  ASSERT_EQUAL_QUIET(W.values.begin(),         M.values.begin());
  ASSERT_EQUAL_QUIET(W.values.end(),           M.values.end());
}
DECLARE_HOST_DEVICE_UNITTEST(TestCooMatrixViewAssignment);


template <typename MemorySpace>
void TestMakeCooMatrixView(void)
{
  typedef int                                                           IndexType;
  typedef float                                                         ValueType;
  typedef typename cusp::coo_matrix<IndexType,ValueType,MemorySpace>    Matrix;
  typedef typename cusp::array1d<IndexType,MemorySpace>::iterator       IndexIterator;
  typedef typename cusp::array1d<ValueType,MemorySpace>::iterator       ValueIterator;
  typedef typename cusp::array1d_view<IndexIterator>                    IndexView;
  typedef typename cusp::array1d_view<ValueIterator>                    ValueView;
  typedef typename cusp::coo_matrix_view<IndexView,IndexView,ValueView> View;

  // construct view from parts
  {
    Matrix M(3, 2, 6);

    View V =
      cusp::make_coo_matrix_view(3, 2, 6,
          cusp::make_array1d_view(M.row_indices),
          cusp::make_array1d_view(M.column_indices),
          cusp::make_array1d_view(M.values));
    
    ASSERT_EQUAL(V.num_rows,    3);
    ASSERT_EQUAL(V.num_cols,    2);
    ASSERT_EQUAL(V.num_entries, 6);

    V.row_indices[0] = 0;  V.column_indices[0] = 1;  V.values[0] = 2;

    ASSERT_EQUAL_QUIET(V.row_indices.begin(),    M.row_indices.begin());
    ASSERT_EQUAL_QUIET(V.row_indices.end(),      M.row_indices.end());
    ASSERT_EQUAL_QUIET(V.column_indices.begin(), M.column_indices.begin());
    ASSERT_EQUAL_QUIET(V.column_indices.end(),   M.column_indices.end());
    ASSERT_EQUAL_QUIET(V.values.begin(),         M.values.begin());
    ASSERT_EQUAL_QUIET(V.values.end(),           M.values.end());
  }
  
  // construct view from matrix
  {
    Matrix M(3, 2, 6);

    View V = cusp::make_coo_matrix_view(M);
    
    ASSERT_EQUAL(V.num_rows,    3);
    ASSERT_EQUAL(V.num_cols,    2);
    ASSERT_EQUAL(V.num_entries, 6);

    V.row_indices[0] = 0;  V.column_indices[0] = 1;  V.values[0] = 2;

    ASSERT_EQUAL_QUIET(V.row_indices.begin(),    M.row_indices.begin());
    ASSERT_EQUAL_QUIET(V.row_indices.end(),      M.row_indices.end());
    ASSERT_EQUAL_QUIET(V.column_indices.begin(), M.column_indices.begin());
    ASSERT_EQUAL_QUIET(V.column_indices.end(),   M.column_indices.end());
    ASSERT_EQUAL_QUIET(V.values.begin(),         M.values.begin());
    ASSERT_EQUAL_QUIET(V.values.end(),           M.values.end());
  }
  
  // construct view from view
  {
    Matrix M(3, 2, 6);

    View X = cusp::make_coo_matrix_view(M);
    View V = cusp::make_coo_matrix_view(X);
    
    ASSERT_EQUAL(V.num_rows,    3);
    ASSERT_EQUAL(V.num_cols,    2);
    ASSERT_EQUAL(V.num_entries, 6);

    V.row_indices[0] = 0;  V.column_indices[0] = 1;  V.values[0] = 2;

    ASSERT_EQUAL_QUIET(V.row_indices.begin(),    M.row_indices.begin());
    ASSERT_EQUAL_QUIET(V.row_indices.end(),      M.row_indices.end());
    ASSERT_EQUAL_QUIET(V.column_indices.begin(), M.column_indices.begin());
    ASSERT_EQUAL_QUIET(V.column_indices.end(),   M.column_indices.end());
    ASSERT_EQUAL_QUIET(V.values.begin(),         M.values.begin());
    ASSERT_EQUAL_QUIET(V.values.end(),           M.values.end());
  }
 
  // construct view from const matrix
  {
    const Matrix M(3, 2, 6);
    
    ASSERT_EQUAL(cusp::make_coo_matrix_view(M).num_rows,    3);
    ASSERT_EQUAL(cusp::make_coo_matrix_view(M).num_cols,    2);
    ASSERT_EQUAL(cusp::make_coo_matrix_view(M).num_entries, 6);

    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).row_indices.begin(),    M.row_indices.begin());
    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).row_indices.end(),      M.row_indices.end());
    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).column_indices.begin(), M.column_indices.begin());
    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).column_indices.end(),   M.column_indices.end());
    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).values.begin(),         M.values.begin());
    ASSERT_EQUAL_QUIET(cusp::make_coo_matrix_view(M).values.end(),           M.values.end());
  }
}
DECLARE_HOST_DEVICE_UNITTEST(TestMakeCooMatrixView);

