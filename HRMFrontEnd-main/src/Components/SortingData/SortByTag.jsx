import axios from 'axios';
import { useState } from 'react';
import { port } from '../../App';
import SortIcon from '../Icons/SortIcon';

function SortByTag({ Empid, empActiveStatus, setAllEmployeelist, allEmp, tag, tagID, obj, setloading }) {
  const [sortByAsc, setSortByAsc] = useState(false);

  const fetchSortedData = (sortBy, order) => {
    setloading('allemp')
    axios
      .get(`${port}root/ems/EmployeesSort/${empActiveStatus}?${order}=${sortBy}`)
      .then(res => {
        console.log(
          'SORTEDDATA',
          `${port}root/ems/EmployeesSort/${empActiveStatus}?${order}=${tagID}`,
        );
        console.log('SORTEDDATA', res);
        setAllEmployeelist(res.data);
        setloading(false)
      })
      .catch(err => {
        console.log('AllEmployee_err', err);
        setloading(false)
      });
  };
  return (
    <>
      <th scope="col">
        {tag}
        {obj && obj.rm_sort != true && allEmp && allEmp.length > 0
          &&
          <button onClick={() => {
            if (sortByAsc) {
              console.log('SORTED', tag);
              setSortByAsc(prev => !prev);
              return fetchSortedData(tagID, 'des');
            }
            else {
              setSortByAsc(prev => !prev);
              return fetchSortedData(tagID, 'asc');
            }
          }} className=" ml-2 text-slate-500 ">

            <SortIcon size={12} />
          </button>}
      </th>
    </>
  );
}

export default SortByTag;
